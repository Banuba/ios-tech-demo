//
//  ViewController.swift
//  TechDemo
//
//  Created by Alexey Ereschenko on 28/08/2018.
//  Copyright © 2018 Banuba. All rights reserved.
//

import UIKit
import AVFoundation
import BNBSdkApi

protocol MainScreenProtocol: AnyObject {
    var effectViewBackground: UIView! { get }
    var effectView: EffectPlayerView! { get }
    var imagePreview: UIImageView! { get }
    var technologiesCollectionView: UICollectionView! { get }
    var effectsCategoriesCollectionView: UICollectionView! { get }
    var effectsGroupsCollectionView: UICollectionView! { get }
    var effectsCollectionView: UICollectionView! { get }
    
    func presentNoCameraAccessView()
    func setLoading(_ isLoading: Bool)
    func setAppSectionPickerVisible(_ isVisible: Bool, animated: Bool)
    func showTooltip(_ tooltip: Tooltip?)
    func setSliderVisible(_ isVisible: Bool, showAboveEffectsList: Bool)
    func setSliderValue(_ value: Float)
    func setSwitchVisible(_ isVisible: Bool)
    func setSwitchValue(_ value: Bool)
    func showHandGesture(_ gesture: HandGesture?)
    func setTooltipButtonVisible(_ isVisible: Bool)
    func showMeasurementDistance(_ distance: String?)
    func showIsGlassesPresent(_ isPresent: Bool?)
    func showSkinColor(_ color: UIColor?)
    func showHairColor(_ color: UIColor?)

    func setPhotoInterfaceVisible(_ enabled : Bool)
    func setClosePhotoButtonVisible(_ enabled : Bool)
    func setImagePreview(_ image : UIImage?)
    func setImagePreviewVisible(_ isVisible: Bool)
    // Used for acne removal
    func enableImagePreviewInteraction(_ enabled: Bool)
    func setEffectViewSize(effectViewSize: CGSize)
    func setEffectViewYshift(effectViewShift: CGFloat)
}

class MainViewController: UIViewController, MainScreenProtocol, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var effectViewBackground: UIView!
    @IBOutlet weak var effectView: EffectPlayerView!
    @IBOutlet weak var effectsCollectionView: UICollectionView!
    @IBOutlet weak var effectsCategoriesCollectionView: UICollectionView!
    @IBOutlet weak var effectsGroupsCollectionView: UICollectionView!
    @IBOutlet weak var technologiesCollectionView: UICollectionView!
    @IBOutlet weak var showPickerButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tooltipContainer: UIView!
    @IBOutlet weak var tooltipLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var effectSwitch: UISwitch!
    @IBOutlet weak var gestureView: HandGestureView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var closePhotoButton: UIButton!
    
    @IBOutlet weak var gestureTipView: GesturesTipView!
    @IBOutlet weak var showTooltipButton: UIButton!
    @IBOutlet weak var measuredDistanceView: MeasuredDistanceView!
    @IBOutlet weak var glassesDetectionView: GlassesDetectionView!
    @IBOutlet weak var skinHairColorView: SkinHairColorView!

    @IBOutlet weak var imagePreview: UIImageView!
    
    @IBOutlet var sectionPickerTopConstraint: NSLayoutConstraint!
    @IBOutlet var sectionPickerBottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var effectsCollectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var effectViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var effectViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var effectViewBottomConstraint: NSLayoutConstraint!
    
    var viewModel: MainScreenViewModel!
    
    private var isSectionPickerShown: Bool = false
    private var tooltipDismissTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        technologiesCollectionView.registerReusableCell(TechnologyCell.self)
        effectsCategoriesCollectionView.registerReusableCell(EffectsCategoryCell.self)
        effectsGroupsCollectionView.registerReusableCell(EffectsGroupCell.self)
        effectsCollectionView.registerReusableCell(EffectPreviewCell.self)
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 14
        section.contentInsets = .init(top: 80, leading: 0, bottom: 0, trailing: 0)
        technologiesCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
        
        setAppSectionPickerVisible(true, animated: false)
        
        gestureTipView.closeHandler = { [weak self] in
            self?.gestureTipView.isHidden = true
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onImagePreviewTap))
        imagePreview.addGestureRecognizer(tapGestureRecognizer)
        
        viewModel.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.viewDidAppear()
    }
    
    func setEffectViewSize(effectViewSize: CGSize) {
        if effectViewSize.width != effectViewWidthConstraint.constant {
            effectViewWidthConstraint.constant = effectViewSize.width
            view.setNeedsLayout()
        }
        if effectViewSize.height != effectViewHeightConstraint.constant {
            effectViewHeightConstraint.constant = effectViewSize.height
            view.setNeedsLayout()
        }
    }
    
    func setEffectViewYshift(effectViewShift: CGFloat) {
        if effectViewShift != effectViewBottomConstraint.constant {
            effectViewBottomConstraint.constant = effectViewShift
            view.setNeedsLayout()
        }
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        // Add additional bottom padding on devices without Face ID
        if view.safeAreaInsets.bottom == 0 {
            effectsCollectionViewBottomConstraint.constant = 16
        }
    }
    
    // MARK: - MainViewProtocol
    
    func presentNoCameraAccessView() {
        let noCameraViewController = NoCameraAccessViewController()
        noCameraViewController.modalPresentationStyle = .currentContext
        present(noCameraViewController, animated: true, completion: nil)
    }
    
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func showTooltip(_ tooltip: Tooltip?) {
        tooltipDismissTimer?.invalidate()
        tooltipDismissTimer = nil
        tooltipContainer.isHidden = true
        gestureTipView.isHidden = true

        guard let tooltip else {
            return
        }
        
        switch tooltip {
        case .nailsColoring, .multipleFaces, .background360, .gangster, .octopus, .acneRemoval, .takePhoto:
            tooltipContainer.isHidden = false
            if case let .timer(seconds) = tooltip.dismissCondition {
                tooltipDismissTimer = .scheduledTimer(
                    withTimeInterval: seconds,
                    repeats: false,
                    block: { [weak self] _ in
                        self?.tooltipContainer.isHidden = true
                        self?.tooltipDismissTimer?.invalidate()
                        self?.tooltipDismissTimer = nil
                    })
            }
        case .handGesture:
            gestureTipView.isHidden = false
        }
        
        switch tooltip {
        case .multipleFaces:
            tooltipLabel.text = "Try with friends"
        case .nailsColoring:
            tooltipLabel.text = "Point the camera at the hand so that the nails are visible"
        case .background360:
            tooltipLabel.text = "Try to tilt your phone"
        case .gangster:
            tooltipLabel.text = "Open your mouth"
        case .octopus:
            tooltipLabel.text = "Smile or open your mouth"
        case .handGesture:
            break
        case .acneRemoval:
            tooltipLabel.text = "Tap the spot you want to fix"
        case .takePhoto:
            tooltipLabel.text = "Take a photo"
        }
    }
    
    func setSliderVisible(_ isVisible: Bool, showAboveEffectsList: Bool) {
        slider.isHidden = !isVisible
        sliderBottomConstraint.constant = showAboveEffectsList ? 108 : 48
    }
    
    func setSliderValue(_ value: Float) {
        slider.value = value
    }
    
    func setSwitchVisible(_ isVisible: Bool) {
        effectSwitch.isHidden = !isVisible
    }
    
    func setSwitchValue(_ value: Bool) {
        effectSwitch.isOn = value
    }
    
    func showHandGesture(_ gesture: HandGesture?) {
        if let gesture {
            gestureView.isHidden = false
            gestureView.update(with: gesture)
        } else {
            gestureView.isHidden = true
        }
    }
    
    func setTooltipButtonVisible(_ isVisible: Bool) {
        showTooltipButton.isHidden = !isVisible
    }
    
    func showMeasurementDistance(_ distance: String?) {
        if let distance {
            measuredDistanceView.isHidden = false
            measuredDistanceView.update(with: distance)
        } else {
            measuredDistanceView.isHidden = true
        }
    }
    
    func showIsGlassesPresent(_ isPresent: Bool?) {
        if let isPresent {
            glassesDetectionView.update(with: isPresent)
            glassesDetectionView.isHidden = false
        } else {
            glassesDetectionView.isHidden = true
        }
    }
    
    func showSkinColor(_ color: UIColor?) {
        if let color {
            skinHairColorView.showSkinColor(color)
            skinHairColorView.isHidden = false
        } else {
            skinHairColorView.isHidden = true
        }
    }
    
    func showHairColor(_ color: UIColor?) {
        if let color {
            skinHairColorView.showHairColor(color)
            skinHairColorView.isHidden = false
        } else {
            skinHairColorView.isHidden = true
        }
    }
    
    func setPhotoInterfaceVisible(_ isVisible: Bool) {
        takePhotoButton.isHidden = !isVisible
        if isVisible {
            switchCameraButton.isHidden = false
        }
    }
    
    func setClosePhotoButtonVisible(_ isVisible: Bool) {
        switchCameraButton.isHidden = isVisible
        closePhotoButton.isHidden = !isVisible
    }
    
    func setImagePreview(_ image : UIImage?) {
        imagePreview.image = image
    }
    
    func setImagePreviewVisible(_ isVisible: Bool) {
        imagePreview.isHidden = !isVisible
        effectView.isHidden = isVisible
    }
    // Used for acne removal
    func enableImagePreviewInteraction(_ enabled: Bool) {
        imagePreview.isUserInteractionEnabled = enabled
    }
    
    func setAppSectionPickerVisible(_ isVisible: Bool, animated: Bool) {
        guard isVisible != isSectionPickerShown else { return }
        
        isSectionPickerShown = isVisible
        sectionPickerTopConstraint.isActive = isVisible
        sectionPickerBottonConstraint.isActive = !isVisible
        
        let image = UIImage(named: isVisible ? "collapse_menu" : "expand_menu")
        showPickerButton.setImage(image, for: .normal)
        
        guard animated else { return }
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: - Actions

    @IBAction func toggleSectionPickerVisibility(_ sender: UIButton) {
        setAppSectionPickerVisible(!isSectionPickerShown, animated: true)
    }
    
    @IBAction func switchCamera(_ sender: UIButton) {
        viewModel.switchCamera()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        viewModel.didChangeSliderValue(sender.value)
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        viewModel.didChangeSwitchValue(sender.isOn)
    }
    
    @IBAction func showTooltip(_ sender: UIButton) {
        viewModel.showTooltipTapped()
    }
    @IBAction func takePhoto(_ sender: Any) {
        viewModel.takePhoto()
    }
    @IBAction func closePhoto(_ sender: Any) {
        viewModel.resetView()
        viewModel.closePhotoEditing()
    }
    @objc func onImagePreviewTap(_ sender: UITapGestureRecognizer) {
        viewModel.didTapImagePreview(sender.location(in: imagePreview))
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView === effectsCollectionView {
            return viewModel.sizeForEffectPreviewCell()
        }
        if collectionView === effectsCategoriesCollectionView {
            return viewModel.sizeForEffectsCategoryCell(at: indexPath)
        }
        if collectionView === effectsGroupsCollectionView {
            return viewModel.sizeForEffectsGroupCell(at: indexPath)
        }
        if collectionView === technologiesCollectionView {
            // Handled by Compositional Layout
            return .zero
        }
        fatalError("Unknown UICollectionView")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView === technologiesCollectionView {
            return .zero
        }
        if collectionView === effectsCategoriesCollectionView {
            return viewModel.insetsForEffectsCategoriesCollectionView()
        }
        if collectionView === effectsGroupsCollectionView {
            return viewModel.insetsForEffectsGroupsCollectionView()
        }
        if collectionView === effectsCollectionView {
            return viewModel.insetsForEffectsPreviewsCollectionView()
        }
        fatalError("Unknown UICollectionView")
    }

    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        if collectionView === technologiesCollectionView {
            viewModel.didSelectTechnology(with: index)
            setAppSectionPickerVisible(false, animated: true)
            return
        }
        if collectionView === effectsCategoriesCollectionView {
            viewModel.didSelectEffectsCategory(with: indexPath, animateSelection: true)
        }
        if collectionView === effectsGroupsCollectionView {
            viewModel.didSelectEffectsGroup(with: indexPath, animateSelection: true)
        }
        if collectionView === effectsCollectionView {
            viewModel.didSelectEffect(with: indexPath, animateSelection: true)
        }
    }
}
