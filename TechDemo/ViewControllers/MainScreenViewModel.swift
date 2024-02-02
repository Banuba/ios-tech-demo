//
//  MainScreenViewModel.swift
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 06.02.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

import UIKit
import AVFoundation
import BNBSdkApi
import BNBSdkCore

final class MainScreenViewModel: BNBEffectActivationCompletionListener, BanubaSdkManagerDelegate {
    unowned var view: MainScreenProtocol

    private var selectedTechnology: Technology
    private var selectedCategory: EffectsCategory
    private var selectedGroup: EffectsGroup
    private var selectedEffect: EffectConfig
    
    private var technologiesDataSource: UICollectionViewDiffableDataSource<Int, TechnologyCellViewModel>!
    private var categoriesDataSource: UICollectionViewDiffableDataSource<Int, EffectsCategoryCellViewModel>!
    private var groupsDataSource: UICollectionViewDiffableDataSource<Int, EffectsGroupCellViewModel>!
    private var effectsDataSource: UICollectionViewDiffableDataSource<Int, EffectPreviewCellViewModel>!
    
    private let sdkManager = BanubaSdkManager()
    private let deviceCapabilities = DeviceCapabilitiesService()
    private var pollingTimer: Timer?
    private var tooltipPollingTimer: Timer?
    private var hairSkinColorEffect: HairSkinColorsWrapper?
    
    private var isEditingPhoto: Bool = false
    private var procImage: UIImage? = nil
    private var hasPhotoTooltipShowed: Bool = false
    // https://banuba.slack.com/archives/C04LE5EL2Q7/p1679482287993989
    // https://banuba.slack.com/archives/C04LE5EL2Q7/p1680764450434149
    private var userDidChangeCameraOrientationInCurrentEffectsGroup = false
    
    // Queue used for hairColor and faceColor effect to save UI responsiveness
    private let customColorQueue = DispatchQueue(label: "com.banuba.getColorQueue")
    private var lastGetColorTimestamp: Date?
    private var isGetColorRunning = false
    private let minGetColorTimeInterval = 0.3; // seconds
    private var effectPlayerConfiguration : EffectPlayerConfiguration? = nil

    init(view: MainScreenProtocol) {
        self.view = view
        selectedTechnology = .virtualTryOn
        selectedCategory = selectedTechnology.categories.first!
        selectedGroup = selectedCategory.effectsGroups.first!
        selectedEffect = selectedGroup.effectsList.first!
        
        
        let token =  <#Client Token place here#>
        BanubaSdkManager.initialize(
            resourcePath: [Bundle.main.bundlePath + "/effects", Bundle.main.bundlePath + "/bnb-resources"],
            clientTokenString: token,
            logLevel: .info
        )
        sdkManager.delegate = self
    }
    
    deinit {
        sdkManager.destroyEffectPlayer()
    }
    
    func viewDidLoad() {
        technologiesDataSource = UICollectionViewDiffableDataSource(
            collectionView: view.technologiesCollectionView,
            cellProvider: { (collectionView, indexPath, viewModel) ->
                UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TechnologyCell.reuseIdentifier, for: indexPath
                ) as? TechnologyCell
                cell?.update(with: viewModel)
                return cell
            })
        categoriesDataSource = UICollectionViewDiffableDataSource(
            collectionView: view.effectsCategoriesCollectionView,
            cellProvider: { (collectionView, indexPath, viewModel) ->
                UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: EffectsCategoryCell.reuseIdentifier, for: indexPath
                ) as? EffectsCategoryCell
                cell?.update(with: viewModel)
                return cell
            })
        groupsDataSource = UICollectionViewDiffableDataSource(
            collectionView: view.effectsGroupsCollectionView,
            cellProvider: { (collectionView, indexPath, viewModel) ->
                UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: EffectsGroupCell.reuseIdentifier, for: indexPath
                ) as? EffectsGroupCell
                cell?.update(with: viewModel)
                return cell
            })
        effectsDataSource = UICollectionViewDiffableDataSource(
            collectionView: view.effectsCollectionView,
            cellProvider: { (collectionView, indexPath, model) ->
                UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: EffectPreviewCell.reuseIdentifier, for: indexPath
                ) as? EffectPreviewCell
                cell?.update(with: model)
                return cell
            })
        
        applyUpdatedTechnologyViewModels()
        applyUpdatedCategoriesViewModels()
        applyUpdatedGroupsViewModels()
        applyUpdatedEffectPreviewModels()
        
        if sdkManager.effectPlayer == nil {
            effectPlayerConfiguration = EffectPlayerConfiguration(
                renderSize: deviceCapabilities.renderSize,
                captureSessionPreset: deviceCapabilities.captureSessionPreset
            )
            sdkManager.setup(configuration: effectPlayerConfiguration!)
            sdkManager.setRenderTarget(view: view.effectView, playerConfiguration: nil)
            sdkManager.effectPlayer?.add(self as BNBEffectActivationCompletionListener)
        }
        sdkManager.input.startCamera()
        
        let sizes = calculateEffectViewSize(
            screenSpace: view.effectViewBackground.bounds.size,
            targetRenderSize: deviceCapabilities.renderSize,
            scalingType: EffectViewScaling.AspectFill
        )
        resizeEffectView(viewSize: sizes.0, croppedSize: sizes.1)
    }
    
    func viewDidAppear() {
        requestCameraPermissionIfNeeded()
    }
    
    func switchCamera() {
        switch sdkManager.input.currentCameraSessionType {
        case .BackCameraSession:
            sdkManager.input.switchCamera(to: .FrontCameraSession, completion: {})
        case .FrontCameraSession:
            sdkManager.input.switchCamera(to: .BackCameraSession, completion: {})
        @unknown default:
            ()
        }
        userDidChangeCameraOrientationInCurrentEffectsGroup = true
    }
    
    func showTooltipTapped() {
        view.showTooltip(selectedEffect.tooltip)
    }
    
    func takePhoto() {
        isEditingPhoto = true
        
        view.setLoading(true)
        view.setPhotoInterfaceVisible(false)
        view.setClosePhotoButtonVisible(true)
        view.showTooltip(nil)
        
        Task {
            await activateEffect(self.selectedEffect)
        }
        
        self.sdkManager.makeCameraPhoto(cameraSettings: CameraPhotoSettings(flashMode: .off), flipFrontCamera: true, completion:
        { [self] (image: UIImage?) -> Void in
            self.procImage = image
            DispatchQueue.main.async {
                self.view.setImagePreview(image)
                self.view.setImagePreviewVisible(true)
                
                self.sdkManager.surfaceChanged(
                    width: self.view.imagePreview.bounds.width,
                    height: self.view.imagePreview.bounds.height
                )
                self.view.setLoading(false)
            }
        })
    }
    
    func closePhotoEditing() {
        resetView()
        
        endPhotoEditing()
        
        view.setImagePreviewVisible(false)
        view.setPhotoInterfaceVisible(true)
        view.setClosePhotoButtonVisible(false)
    }
    
    func endPhotoEditing() {
        sdkManager.unloadEffect(effect: sdkManager.currentEffect())
        
        sdkManager.surfaceChanged(
            width: self.view.effectView.bounds.width,
            height: self.view.effectView.bounds.height
        )
        sdkManager.input.startCamera()
        switch selectedEffect.preferredCamera {
        case .back:
            sdkManager.input.setCameraSessionType(.BackCameraSession)
        case .front:
            sdkManager.input.setCameraSessionType(.FrontCameraSession)
        }
        sdkManager.startEffectPlayer()
        
        isEditingPhoto = false
    }
    
    // MARK: - Cell sizes and insets
    
    func sizeForEffectPreviewCell() -> CGSize {
        EffectPreviewCell.cellSize
    }
    
    func sizeForEffectsCategoryCell(at indexPath: IndexPath) -> CGSize {
        guard let vm = categoriesDataSource.itemIdentifier(for: indexPath) else { return .zero }
        let height = view.effectsCategoriesCollectionView.bounds.height
        let width = EffectsCategoryCell.requiredWidth(with: vm)
        return CGSize(width: width, height: height)
    }
    
    func sizeForEffectsGroupCell(at indexPath: IndexPath) -> CGSize {
        guard let vm = groupsDataSource.itemIdentifier(for: indexPath) else { return .zero }
        let height: CGFloat = 41
        let width = EffectsGroupCell.requiredWidth(with: vm)
        return CGSize(width: width, height: height)
    }
    
    func insetsForEffectsCategoriesCollectionView() -> UIEdgeInsets {
        let lastIndex = selectedTechnology.categories.count - 1
        guard let firstVM = categoriesDataSource.itemIdentifier(for: .zero),
              let lastVM = categoriesDataSource.itemIdentifier(for: .init(item: lastIndex, section: 0)) else {
            return .zero
        }
        let firstCellWidth = EffectsCategoryCell.requiredWidth(with: firstVM)
        let lastCellWidth = EffectsCategoryCell.requiredWidth(with: lastVM)
        
        let cvWidth = view.effectsCategoriesCollectionView.bounds.width
        let leftInset = (cvWidth - firstCellWidth) / 2
        let rightInset = (cvWidth - lastCellWidth) / 2
        return .init(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
    func insetsForEffectsGroupsCollectionView() -> UIEdgeInsets {
        let lastIndex = selectedCategory.effectsGroups.count - 1
        guard let firstVM = groupsDataSource.itemIdentifier(for: .zero),
              let lastVM = groupsDataSource.itemIdentifier(for: .init(item: lastIndex, section: 0)) else {
            return .zero
        }
        let firstCellWidth = EffectsGroupCell.requiredWidth(with: firstVM)
        let lastCellWidth = EffectsGroupCell.requiredWidth(with: lastVM)
        
        let cvWidth = view.effectsGroupsCollectionView.bounds.width
        let leftInset = (cvWidth - firstCellWidth) / 2
        let rightInset = (cvWidth - lastCellWidth) / 2
        return .init(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
    func insetsForEffectsPreviewsCollectionView() -> UIEdgeInsets {
        let cellWidth = EffectPreviewCell.cellSize.width
        let cvWidth = view.effectsCollectionView.bounds.width
        let inset = (cvWidth - cellWidth) / 2
        return .init(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    // MARK: - Selection handling
    
    func didSelectTechnology(with index: Int, effectsCategoryToSelectIndex: Int = 0) {
        let newTechnology = Technology.allCases[index]
        selectedTechnology = newTechnology
        
        applyUpdatedTechnologyViewModels()
        
        didSelectEffectsCategory(with: .init(item: effectsCategoryToSelectIndex, section: 0), animateSelection: false)
    }
    
    func didSelectEffectsCategory(with indexPath: IndexPath, animateSelection: Bool) {
        let newCategory = selectedTechnology.categories[indexPath.row]
        guard newCategory != selectedCategory else { return }
        selectedCategory = newCategory
        
        applyUpdatedCategoriesViewModels()
        
        view.effectsCategoriesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animateSelection)
        previouslyShownTooltip = nil
        userDidChangeCameraOrientationInCurrentEffectsGroup = false
        didSelectEffectsGroup(with: .zero, animateSelection: false)
    }
    
    func didSelectEffectsGroup(with indexPath: IndexPath, animateSelection: Bool) {
        let newGroup = selectedCategory.effectsGroups[indexPath.item]
        guard newGroup != selectedGroup else { return }
        selectedGroup = newGroup
        
        applyUpdatedGroupsViewModels()
        
        if selectedCategory.effectsGroups.count > 1 {
            view.effectsGroupsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animateSelection)
        }
        didSelectEffect(with: .zero, animateSelection: false)
    }
    
    func didSelectEffect(with indexPath: IndexPath, animateSelection: Bool) {
        let newEffect = selectedGroup.effectsList[indexPath.item]
        guard newEffect != selectedEffect else { return }
        selectedEffect = newEffect
        
        applyUpdatedEffectPreviewModels()
        
        Task {
            await prepareEffect(newEffect)
        }
        
        if selectedGroup.effectsList.count > 1 {
            view.effectsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animateSelection)
        }
    }
    
    func didChangeSliderValue(_ value: Float) {
        callOnDataUpdateMethod(with: value)
    }
    
    func didChangeSwitchValue(_ value: Bool) {
        callOnDataUpdateMethod(with: value ? 1 : 0)
    }

    // MARK: - BNBEffectActivationCompletionListener
    // https://banuba.slack.com/archives/C04LE5EL2Q7/p1679414292791979
    private var previouslyShownTooltip: Tooltip?
    
    func onEffectActivationFinished(_ url: String) {
        DispatchQueue.main.async {
            self.view.setLoading(false)
            if let hint = self.selectedEffect.tooltip, hint != self.previouslyShownTooltip {
                self.view.showTooltip(hint)
                self.previouslyShownTooltip = hint
                if case let .pollingMethod(name) = hint.dismissCondition {
                    self.tooltipPollingTimer = .scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
                        self?.pollTooltipDismissCallback(methodName: name)
                    }
                }
            } else {
                self.view.showTooltip(nil)
            }
        }
    }
    
    // MARK: - BanubaSdkManagerDelegate
    
    func willOutput(pixelBuffer: CVPixelBuffer) {
        guard selectedEffect.effect == .hairColor || selectedEffect.effect == .skinColor,
            let effect = hairSkinColorEffect else { return }
        
        let currentTime = Date()
        let timeSinceLastGetColor = currentTime.timeIntervalSince(lastGetColorTimestamp ?? Date.distantPast)
                
        if isGetColorRunning || timeSinceLastGetColor < minGetColorTimeInterval {
            return;
        }
        
        customColorQueue.async {
            self.isGetColorRunning = true
            self.lastGetColorTimestamp = Date()
            let model = effect.calculateColors(from: pixelBuffer)
            self.isGetColorRunning = false
            
            DispatchQueue.main.async {
                switch self.selectedEffect.effect {
                case .skinColor:
                    self.view.showSkinColor(model.skinColor ?? .clear)
                case .hairColor:
                    self.view.showHairColor(model.hairColor ?? .clear)
                default:
                    break
                }
            }
        }
    }
    
    func willPresentFramebuffer(renderSize: CGSize) { }
    
    // MARK: - Deep Links Handling
    
    func handleDeepLinkRoute(_ route: DeepLinkRoute) {
        switch route {
        case .technology(let id):
            if let index = Technology.allCases.firstIndex(where: { $0.deepLinkId == id }) {
                didSelectTechnology(with: index)
                view.setAppSectionPickerVisible(false, animated: true)
            }
        case .category(let id, let technologyId):
            if let technology = Technology.allCases.first(where: { $0.deepLinkId == technologyId }),
               let technologyIndex = Technology.allCases.firstIndex(of: technology),
               let categoryIndex = technology.categories.firstIndex(where: { $0.deepLinkId == id }) {
                didSelectTechnology(with: technologyIndex, effectsCategoryToSelectIndex: categoryIndex)
                view.setAppSectionPickerVisible(false, animated: true)
            }
        }
    }
    
    // MARK: - Private
    
    private func applyUpdatedTechnologyViewModels() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, TechnologyCellViewModel>()
        snapshot.appendSections([0])
        let models = Technology.allCases.map {
            TechnologyCellViewModel(technology: $0, isSelected: $0 == selectedTechnology)
        }
        snapshot.appendItems(models)
        technologiesDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func applyUpdatedCategoriesViewModels() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, EffectsCategoryCellViewModel>()
        snapshot.appendSections([0])
        let models = selectedTechnology.categories.map {
            EffectsCategoryCellViewModel(category: $0, isSelected: $0 == selectedCategory)
        }
        snapshot.appendItems(models)
        categoriesDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func applyUpdatedGroupsViewModels() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, EffectsGroupCellViewModel>()
        snapshot.appendSections([0])
        let models = selectedCategory.effectsGroups.map {
            EffectsGroupCellViewModel(title: $0.title, isSelected: $0 == selectedGroup)
        }
        if models.count > 1 {
            snapshot.appendItems(models)
        }
        groupsDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func applyUpdatedEffectPreviewModels() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, EffectPreviewCellViewModel>()
        snapshot.appendSections([0])
        let models = selectedGroup.effectsList.map {
            EffectPreviewCellViewModel(preview: $0.preview, isSelected: $0 == selectedEffect)
        }
        if models.count > 1 {
            snapshot.appendItems(models)
        }
        effectsDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func requestCameraPermissionIfNeeded() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] (granted) in
                DispatchQueue.main.async {
                    self?.requestCameraPermissionIfNeeded()
                }
            }
        case .authorized:
            Task {
                await prepareEffect(selectedEffect)
            }
        default:
            view.presentNoCameraAccessView()
        }
    }
    
    @MainActor
    private func prepareEffect(_ config: EffectConfig) async {
        view.setLoading(true)
        
        if (isEditingPhoto) {
            endPhotoEditing()
        }
        resetView()
        
        if config.mediaType == .photo {
            sdkManager.unloadEffect(effect: sdkManager.currentEffect())
            view.setPhotoInterfaceVisible(true)
            if (!hasPhotoTooltipShowed) {
                hasPhotoTooltipShowed = true
                view.showTooltip(.takePhoto)
            }
            view.setLoading(false)
        } else {
            await activateEffect(config)
        }
    }
    
    func resetView() {
        tooltipPollingTimer?.invalidate()
        tooltipPollingTimer = nil
        pollingTimer?.invalidate()
        pollingTimer = nil
        
        view.setSliderVisible(false, showAboveEffectsList: false)
        view.setSwitchVisible(false)
        
        view.setTooltipButtonVisible(false)
        view.showTooltip(nil)
        
        view.showHandGesture(nil)
        view.showMeasurementDistance(nil)
        view.showIsGlassesPresent(nil)
        view.showHairColor(nil)
        view.showSkinColor(nil)
        
        view.setClosePhotoButtonVisible(false)
        view.setPhotoInterfaceVisible(false)
        view.enableImagePreviewInteraction(false)
        view.setImagePreviewVisible(false)
    }
    
    private func converTouch(touch: CGPoint) -> [NSNumber: BNBTouch] {
        var result: [NSNumber: BNBTouch] = [:]
        result[NSNumber(value: 0)] = BNBTouch(x: Float(touch.x), y: Float(touch.y), id: Int64(0))
        return result
    }
    
    private var coalesceTrack = 0
    private func coalesce(timeout: TimeInterval, block: @escaping ()->()) {
        coalesceTrack = coalesceTrack + 1
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) { [weak self] in
            self?.coalesceTrack = self!.coalesceTrack - 1
            if self?.coalesceTrack == 0 {
                block()
            }
        }
    }
    
    func didTapImagePreview(_ tapLocation: CGPoint) {
        var point = tapLocation
        point.x *= UIScreen.main.scale
        point.y *= UIScreen.main.scale
        
        //call effect specific function(see test_Acne config.js)
        sdkManager.effectPlayer?.effectManager()?.current()?.evalJs("setFitMode(0)", resultCallback: nil)
        
        sdkManager.effectPlayer?.getInputManager()?.onTouchesEnded(converTouch(touch: point));
            
        coalesce(timeout: 0.350) { [weak self] in
            self?.sdkManager.processImageData(self!.procImage!) { [weak self] (image) in
                self?.procImage = image
                DispatchQueue.main.async { [weak self] in
                    self?.view.setImagePreview(image)
                }
            }
        }
    }
    
    func resizeEffectView(viewSize: CGSize, croppedSize: CGSize) {
        view.setEffectViewSize(effectViewSize: viewSize)
        let Yshift = -croppedSize.height / 2
        view.setEffectViewYshift(effectViewShift: Yshift)
    }
    
    func calculateEffectViewSize(screenSpace: CGSize, targetRenderSize: CGSize, scalingType: EffectViewScaling) -> (CGSize, CGSize, CGSize) {
        var effectViewSize: CGSize = CGSize()
        var effectViewCropSize: CGSize = CGSize()
        switch scalingType {
        case .AspectFill:
            let fillRect = CGRect.makeRectFill(
                originalSize: targetRenderSize,
                fillingSize: screenSpace
            )
            effectViewSize = fillRect.size.rounded()
            effectViewCropSize = CGSize(width: fillRect.minX, height: fillRect.minY)
        case .FitScreen:
            effectViewSize = screenSpace
            effectViewCropSize = CGSize(width: 0, height: 0)
        }
        
        let renderSize = CGRect.makeRectFit(
            originalSize: effectViewSize,
            fittingSize: targetRenderSize
        ).size.rounded()
        
        return (effectViewSize, effectViewCropSize, renderSize)
    }
    
    @MainActor
    private func activateEffect(_ config: EffectConfig) async {
        switch config.control {
        case .none:
            view.setSliderVisible(false, showAboveEffectsList: false)
            view.setSwitchVisible(false)
        case let .slider(defaultValue):
            view.setSwitchVisible(false)
            view.setSliderVisible(true, showAboveEffectsList: selectedGroup.effectsList.count > 1)
            view.setSliderValue(defaultValue)
        case .some(.switch):
            view.setSliderVisible(false, showAboveEffectsList: false)
            view.setSwitchVisible(true)
            view.setSwitchValue(true)
        }
        
        let sizes = calculateEffectViewSize(
            screenSpace: view.effectViewBackground.bounds.size,
            targetRenderSize: deviceCapabilities.renderSize,
            scalingType: config.screenScaling
        )
        
        if (effectPlayerConfiguration!.renderSize != sizes.2) {
            effectPlayerConfiguration!.renderSize = sizes.2
            
            sdkManager.setRenderTarget(view: view.effectView, playerConfiguration: effectPlayerConfiguration!)
            resizeEffectView(viewSize: sizes.0, croppedSize: sizes.1)
        }
        
        switch config.effect {
        case let .standard(name):
            let effect = await sdkManager.loadEffect(name)
            if let js = config.jsConfig {
                effect?.evalJs(js, resultCallback: nil)
            }
            hairSkinColorEffect = nil
        case .skinColor, .hairColor:
            sdkManager.unloadEffect(effect: sdkManager.currentEffect())
            hairSkinColorEffect = HairSkinColorsWrapper()
            var features : Set<NSNumber> = Set()
            switch self.selectedEffect.effect {
                case .skinColor:
                features.insert(NSNumber(value: ColorFeature.skinColor.rawValue))
                case .hairColor:
                    features.insert(NSNumber(value: ColorFeature.hairColor.rawValue))
                default:
                    break;
            }
            hairSkinColorEffect!.setFeatureSet(features)
            view.setLoading(false)
        case .acneRemoval:
            let _ = await self.sdkManager.loadEffect("test_Acne")
        
            view.enableImagePreviewInteraction(true)
            view.setLoading(false)
        }
        
        if !userDidChangeCameraOrientationInCurrentEffectsGroup {
            switch config.preferredCamera {
            case .back:
                sdkManager.input.setCameraSessionType(.BackCameraSession)
            case .front:
                sdkManager.input.setCameraSessionType(.FrontCameraSession)
            }
        }
        
        if case let .slider(defaultValue) = config.control {
            callOnDataUpdateMethod(with: defaultValue)
        }
        sdkManager.startEffectPlayer()
        sdkManager.effectPlayer?.effectManager()?.setEffectVolume(1)
        
        switch config.pollingMethod {
        case .gesturesDetection:
            pollingTimer = .scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self] _ in
                self?.pollGestureState()
            })
            view.showHandGesture(.noGesture)
            view.setTooltipButtonVisible(true)
        case .distanceMeasurement:
            pollingTimer = .scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
                self?.pollMeasuredDistance()
            })
        case .glassesDetection:
            pollingTimer = .scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self] _ in
                self?.pollGlassesPresence()
            })
            view.showIsGlassesPresent(false)
        case .none:
            break
        }
    }
    
    private func callOnDataUpdateMethod(with value: Float) {
        sdkManager.currentEffect()?.callJsMethod("onDataUpdate", params: String(value))
    }
    
    private func pollGestureState() {
        let callback = JsCallbackWrapper { [weak self] in
            let gesture = HandGesture(rawValue: $0) ?? .noGesture
            self?.view.showHandGesture(gesture)
        }
        sdkManager.currentEffect()?.evalJs("getGesture()", resultCallback: callback)
    }
    
    private func pollMeasuredDistance() {
        let callback = JsCallbackWrapper { [weak self] in
            self?.view.showMeasurementDistance($0)
        }
        sdkManager.currentEffect()?.evalJs("onDataUpdate()", resultCallback: callback)
    }
    
    private func pollGlassesPresence() {
        let callback = JsCallbackWrapper { [weak self] in
            if let bool = Bool($0) {
                self?.view.showIsGlassesPresent(bool)
            }
        }
        sdkManager.currentEffect()?.evalJs("onDataUpdate()", resultCallback: callback)
    }
    
    private func pollTooltipDismissCallback(methodName: String) {
        let callback = JsCallbackWrapper { [weak self] in
            if let bool = Bool($0), bool {
                self?.view.showTooltip(nil)
                self?.tooltipPollingTimer?.invalidate()
                self?.tooltipPollingTimer = nil
            }
        }
        sdkManager.currentEffect()?.evalJs(methodName, resultCallback: callback)
    }
}

extension BanubaSdkManager {
    func loadEffect(_ name: String) async -> BNBEffect? {
        await withCheckedContinuation {
            let effect = loadEffect(name, synchronous: true)
            $0.resume(returning: effect)
        }
    }
}

class JsCallbackWrapper: BNBJsCallback {
    let closure: (String) -> Void
    
    init(closure: @escaping (String) -> Void) {
        self.closure = closure
    }
    
    func onResult(_ result: String) {
        DispatchQueue.main.async { [closure] in
            closure(result)
        }
    }
}
