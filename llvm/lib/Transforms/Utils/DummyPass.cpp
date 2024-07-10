
#include "llvm/Transforms/Utils/DummyPass.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/DebugInfoMetadata.h"
#include "llvm/IR/DebugInfo.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/DebugProgramInstruction.h"
#include "llvm/IR/Instruction.h"



using namespace llvm;

PreservedAnalyses DummyPass::run(Function &F,
                                      FunctionAnalysisManager &AM) {

  
    unsigned dbgValueCount = 0;
    unsigned dbgValueDeclare = 0;


    for (BasicBlock &BB : F) {
        for (Instruction &I : BB) {
            
           for (DbgVariableRecord &DVR : filterDbgVars(I.getDbgRecordRange())) {
                
                if (DVR.isDbgValue())
                    ++dbgValueCount;

                if (DVR.isDbgDeclare())
                    ++dbgValueDeclare;

            }
        }
    }

    errs() << "Function: " << F.getName() << "\n";
    errs() << "  llvm.dbg.values : " << dbgValueCount << "\n";
    errs() << "  llvm.dbg.declare : " << dbgValueDeclare << "\n";

  return PreservedAnalyses::all();
}

