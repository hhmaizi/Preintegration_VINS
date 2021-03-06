function [] = fn_CalcShowUncert_general( RptFeatureObs, ImuTimestamps, ...
                    dtIMU, ef, K, X_obj, nPoses, nPts, ...
                    Jd, CovMatrixInv, nIMUrate, nIMUdata )
    
    global PreIntegration_options Data_config
    
    load( [ Data_config.TEMP_DIR 'Zobs.mat' ]); 
    load( [ Data_config.TEMP_DIR 'Zobs.mat' ]); 

    J_obj = SLAM_Jacobian_Define( );
    J_obj = fn_Jacobian_dUv_dX(J_obj, K, X_obj, Zobs, nPoses, nPts, nIMUdata, ImuTimestamps, RptFeatureObs );		
    if ( PreIntegration_options.bPreInt == 1 )
        J_obj = fn_Jacobian_dIntlDelta_dX( J_obj, dtIMU, Jd, nPoses, nPts, X_obj, Zobs );
    else
        J_obj = fn_Jacobian_dImu_dX( J_obj, dtIMU, Jd, nPoses, nPts, nIMUrate, nIMUdata, X_obj, Zobs  );
    end
    
    J = SLAM_J_Object2Matrix( J_obj, Zobs, X_obj );
    
%%%%%%%%%%%
Info = J'*CovMatrixInv*J;

% Tao = linsolve(Info, eye(size(Info,1)));%Info \
% Td = diag(Tao);
Td = fn_GetSigmFromInfo(Info);
Td = 3*sqrt(Td);
%nTd = -Td;

fn_ShowEstmBnd_general(ef, Td, nPoses, nPts, nIMUdata);%fnShowEstmBnd(ef, Td, nPoses, nPts, nIMUrate, bPreInt);


% 