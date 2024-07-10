
#include "llvm/Transforms/Utils/DummyPassTransform.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/DebugInfoMetadata.h"
#include "llvm/IR/DebugInfo.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/DebugProgramInstruction.h"
#include "llvm/IR/Instruction.h"



using namespace llvm;

PreservedAnalyses DummyPassTransform::run(Function &F,
                                      FunctionAnalysisManager &AM) {

  
    bool Changed = false;

    for (BasicBlock &BB : F) {
        for (Instruction &I : BB) {
            
        for (DbgVariableRecord &DVR : make_early_inc_range(filterDbgVars(I.getDbgRecordRange()))) {
                
                DVR.eraseFromParent();
               
                Changed = true;

            }
        }
    }


    if (Changed) {
        return PreservedAnalyses::none();
    }

    // Indicate all analyses are preserved
    return PreservedAnalyses::all();
}



