from pd_biometrics import PDBiometrics
import random


pdbmtrcs = PDBiometrics()
# pdbmtrcs.plotOpenPoseAverageConfidence()
pdbmtrcs.trainAndTestMulticlassRandomForest('multi', randomize=True)