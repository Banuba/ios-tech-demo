//
//  BNBTechnology_Execute.h
//  BanubaDemo
//
//  Created by Pavel Bulochkin on 27.02.2018.
//

#ifndef BNBTechnology_Execute_h
#define BNBTechnology_Execute_h

namespace std_exp = std;
////////////////////////////////////////////////////////////////////////////////

class BNBTechnologyExecute
{
public:
    static float GetModelsVideoFieldOfView() { return modelsVideoFieldOfView; }
    
protected:
    static inline float modelsVideoFieldOfView = 0.0f;
};

#endif /* BNBTechnology_Execute_h */
