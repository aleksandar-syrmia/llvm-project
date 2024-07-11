
#include "llvm/Transforms/Utils/DummyPassTransform.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Pass.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"



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

