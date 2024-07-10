#ifndef LLVM_TRANSFORMS_UTILS_DUMMYPASSTRANSFORM_H
#define LLVM_TRANSFORMS_UTILS_DUMMYPASSTRANSFORM_H

#include "llvm/IR/PassManager.h"

namespace llvm {

class DummyPassTransform : public PassInfoMixin<DummyPassTransform> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);
};

} // namespace llvm

#endif // LLVM_TRANSFORMS_UTILS_DUMMYPASSTRANSFORM_H
