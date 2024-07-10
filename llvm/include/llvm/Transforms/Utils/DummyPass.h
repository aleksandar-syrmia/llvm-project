#ifndef LLVM_TRANSFORMS_UTILS_DUMMYPASS_H
#define LLVM_TRANSFORMS_UTILS_DUMMYPASS_H

#include "llvm/IR/PassManager.h"

namespace llvm {

class DummyPass : public PassInfoMixin<DummyPass> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);
};

} // namespace llvm

#endif // LLVM_TRANSFORMS_UTILS_DUMMYPASS_H
