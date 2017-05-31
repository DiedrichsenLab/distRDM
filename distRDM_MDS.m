%% RDM Distances

clc
close all

%function out = distance_rdm_MDS(sj, varargin)
% Will calculate the euclidean distance between RDMs of multiple tessels
% and perform multidimentional scaling to compare these new RDMs. 
%
%% ARGUMENTS
%      sj : Subject number to use (scalar for now)
%
%% RETURNS
%        RMD : RDM matrix of condition RDMs for all tessels
%                
%% FUNCTION
sj = 10;

%Parameters
dPath = 'Z:\data\super_cerebellum\sc1\RegionOfInterest\'; %Data path
nSjs  = 21; %Number of subjects

%Loading and formatting data
if ~exist('Cor', 'var') %Load only if not loaded
    Cor = load([dPath,'glm4\allRDM_162_tessellation_hem.mat']);  % Cortex
    Cer = load([dPath,'glm4\allRDM_cerebellum_grey.mat']);       % Cerebelluim
    
    %% Data preparation
    
    %Taking prewhitening data
    Cor = getrow(Cor, Cor.method_num==2); 
    Cer = getrow(Cer, Cer.method_num==2);
    
    %Taking single subject
    Cor = getrow(Cor, Cor.SN == sj);      
    Cer = getrow(Cer, Cer.SN == sj); 
    
    %Information about tessels
    InfoCor = load([dPath,'data\162_reorder.mat']);
    
    %Taking relevant tesselations only
    RDM = [Cor.RDM(InfoCor.good == 1,:); Cer.RDM];
    
    %Indexes of RDM baed on cortex (1) vs cerebellum(2)
    regionIdx = [ones(sum(InfoCor.good == 1), 1); ones(size(Cer.RDM,1),1)*2];    
end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 

%Normalization of RDMs
RDM_meanSub = bsxfun(@minus, RDM, mean(RDM, 2));
RDM_standar = bsxfun(@times, RDM, 1 ./ std(RDM, [], 2));


%Multidimentional Scaling Non normalized
MDS = MDScalc(RDM,'pTitle', 'MDS of RDMs',      ...
                  'colorIdx', regionIdx, 'colCode', ['r','b']);

%Multidimentional Mean Substraced
MDS_meanSub = MDScalc(RDM_meanSub, 'pTitle', 'MDS of Mean Substracted RDMs',...
                                   'colorIdx', regionIdx, 'colCode', ['r','b']);
          
%Multidimentional Standardized
MDS_standar = MDScalc(RDM_standar, 'pTitle', 'MDS of Standardized RDMs',...
                                   'colorIdx', regionIdx, 'colCode', ['r','b']);
                               
%Correlation dissimilarity
MDS_corr = MDScalc(RDM, 'pTitle', 'MDS of Correlation RDMs',...
                        'colorIdx', regionIdx, 'colCode', ['r','b'], ... 
                        'dsimMetric', 'correlation');
                    
%Correlation dissimilarity Standardized
MDS_corrStand = MDScalc(RDM_standar, 'pTitle', 'MDS of Correlation of Standardized RDMs',...
                        'colorIdx', regionIdx, 'colCode', ['r','b'], ... 
                        'dsimMetric', 'correlation');
