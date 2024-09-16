from pd_biometrics import PDBiometrics
import random

pdbmtrcs = PDBiometrics()
pdbmtrcs.trainAndTestMulticlassRandomForest(approach='multi', randomize=False)
