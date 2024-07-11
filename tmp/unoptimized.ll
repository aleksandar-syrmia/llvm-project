; ModuleID = './tmp/code.ll'
source_filename = "./tmp/code.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [16 x i8] c"Element %d: %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [17 x i8] c"Sum of data: %d\0A\00", align 1
@__const.main.arr = private unnamed_addr constant [5 x i32] [i32 1, i32 2, i32 3, i32 4, i32 5], align 16
@str = private unnamed_addr constant [27 x i8] c"Non-positive sum detected.\00", align 1
@str.5 = private unnamed_addr constant [23 x i8] c"Positive sum detected.\00", align 1
@str.6 = private unnamed_addr constant [16 x i8] c"Array contents:\00", align 1

; Function Attrs: nofree nounwind uwtable
define dso_local void @printArray(ptr nocapture noundef readonly %0, i32 noundef %1) local_unnamed_addr #0 !dbg !9 {
    #dbg_value(ptr %0, !16, !DIExpression(), !20)
    #dbg_value(i32 %1, !17, !DIExpression(), !20)
    #dbg_value(i32 0, !18, !DIExpression(), !21)
  %3 = icmp sgt i32 %1, 0, !dbg !22
  br i1 %3, label %4, label %.loopexit, !dbg !24

4:                                                ; preds = %2
  %5 = zext nneg i32 %1 to i64, !dbg !22
  br label %6, !dbg !24

.loopexit:                                        ; preds = %6, %2
  ret void, !dbg !25

6:                                                ; preds = %6, %4
  %7 = phi i64 [ 0, %4 ], [ %12, %6 ]
    #dbg_value(i64 %7, !18, !DIExpression(), !21)
  %8 = getelementptr inbounds i32, ptr %0, i64 %7, !dbg !26
  %9 = load i32, ptr %8, align 4, !dbg !26, !tbaa !28
  %10 = trunc i64 %7 to i32, !dbg !32
  %11 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i32 noundef %10, i32 noundef %9), !dbg !32
  %12 = add nuw nsw i64 %7, 1, !dbg !33
    #dbg_value(i64 %12, !18, !DIExpression(), !21)
  %13 = icmp eq i64 %12, %5, !dbg !22
  br i1 %13, label %.loopexit, label %6, !dbg !24, !llvm.loop !34
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr nocapture noundef readonly, ...) local_unnamed_addr #1

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read) uwtable
define dso_local i32 @sumArray(ptr nocapture noundef readonly %0, i32 noundef %1) local_unnamed_addr #2 !dbg !38 {
    #dbg_value(ptr %0, !42, !DIExpression(), !47)
    #dbg_value(i32 %1, !43, !DIExpression(), !47)
    #dbg_value(i32 0, !44, !DIExpression(), !47)
    #dbg_value(i32 0, !45, !DIExpression(), !48)
  %3 = icmp sgt i32 %1, 0, !dbg !49
  br i1 %3, label %4, label %.loopexit, !dbg !51

4:                                                ; preds = %2
  %5 = zext nneg i32 %1 to i64, !dbg !49
  %min.iters.check = icmp ult i32 %1, 4, !dbg !51
  br i1 %min.iters.check, label %scalar.ph.preheader, label %vector.ph, !dbg !51

scalar.ph.preheader:                              ; preds = %middle.block, %4
  %.ph = phi i64 [ 0, %4 ], [ %n.vec, %middle.block ]
  %.ph1 = phi i32 [ 0, %4 ], [ %9, %middle.block ]
  br label %scalar.ph, !dbg !51

vector.ph:                                        ; preds = %4
  %n.vec = and i64 %5, 2147483644, !dbg !51
  br label %vector.body, !dbg !51

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ], !dbg !52
  %vec.phi = phi <4 x i32> [ zeroinitializer, %vector.ph ], [ %7, %vector.body ]
  %6 = getelementptr inbounds i32, ptr %0, i64 %index, !dbg !53
  %wide.load = load <4 x i32>, ptr %6, align 4, !dbg !53, !tbaa !28
  %7 = add <4 x i32> %wide.load, %vec.phi, !dbg !55
  %index.next = add nuw i64 %index, 4, !dbg !52
  %8 = icmp eq i64 %index.next, %n.vec, !dbg !52
  br i1 %8, label %middle.block, label %vector.body, !dbg !52, !llvm.loop !56

middle.block:                                     ; preds = %vector.body
  %9 = tail call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %7), !dbg !51
  %cmp.n = icmp eq i64 %n.vec, %5, !dbg !51
  br i1 %cmp.n, label %.loopexit, label %scalar.ph.preheader, !dbg !51

.loopexit:                                        ; preds = %scalar.ph, %middle.block, %2
  %10 = phi i32 [ 0, %2 ], [ %9, %middle.block ], [ %15, %scalar.ph ], !dbg !47
  ret i32 %10, !dbg !60

scalar.ph:                                        ; preds = %scalar.ph.preheader, %scalar.ph
  %11 = phi i64 [ %16, %scalar.ph ], [ %.ph, %scalar.ph.preheader ]
  %12 = phi i32 [ %15, %scalar.ph ], [ %.ph1, %scalar.ph.preheader ]
    #dbg_value(i64 %11, !45, !DIExpression(), !48)
    #dbg_value(i32 %12, !44, !DIExpression(), !47)
  %13 = getelementptr inbounds i32, ptr %0, i64 %11, !dbg !53
  %14 = load i32, ptr %13, align 4, !dbg !53, !tbaa !28
  %15 = add nsw i32 %14, %12, !dbg !55
    #dbg_value(i32 %15, !44, !DIExpression(), !47)
  %16 = add nuw nsw i64 %11, 1, !dbg !52
    #dbg_value(i64 %16, !45, !DIExpression(), !48)
  %17 = icmp eq i64 %16, %5, !dbg !49
  br i1 %17, label %.loopexit, label %scalar.ph, !dbg !51, !llvm.loop !61
}

; Function Attrs: nofree nounwind uwtable
define dso_local void @processData(ptr nocapture noundef readonly %0, i32 noundef %1) local_unnamed_addr #0 !dbg !62 {
    #dbg_value(ptr %0, !64, !DIExpression(), !67)
    #dbg_value(i32 %1, !65, !DIExpression(), !67)
    #dbg_value(ptr %0, !42, !DIExpression(), !68)
    #dbg_value(i32 %1, !43, !DIExpression(), !68)
    #dbg_value(i32 0, !44, !DIExpression(), !68)
    #dbg_value(i32 0, !45, !DIExpression(), !70)
  %3 = icmp sgt i32 %1, 0, !dbg !71
  br i1 %3, label %5, label %.thread, !dbg !72

.thread:                                          ; preds = %2
    #dbg_value(i32 0, !66, !DIExpression(), !67)
  %4 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.1, i32 noundef 0), !dbg !73
  br label %20

5:                                                ; preds = %2
  %6 = zext nneg i32 %1 to i64, !dbg !71
  %min.iters.check = icmp ult i32 %1, 4, !dbg !72
  br i1 %min.iters.check, label %scalar.ph.preheader, label %vector.ph, !dbg !72

vector.ph:                                        ; preds = %5
  %n.vec = and i64 %6, 2147483644, !dbg !72
  br label %vector.body, !dbg !72

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ], !dbg !74
  %vec.phi = phi <4 x i32> [ zeroinitializer, %vector.ph ], [ %8, %vector.body ]
  %7 = getelementptr inbounds i32, ptr %0, i64 %index, !dbg !75
  %wide.load = load <4 x i32>, ptr %7, align 4, !dbg !75, !tbaa !28
  %8 = add <4 x i32> %wide.load, %vec.phi, !dbg !76
  %index.next = add nuw i64 %index, 4, !dbg !74
  %9 = icmp eq i64 %index.next, %n.vec, !dbg !74
  br i1 %9, label %middle.block, label %vector.body, !dbg !74, !llvm.loop !77

middle.block:                                     ; preds = %vector.body
  %10 = tail call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %8), !dbg !72
  %cmp.n = icmp eq i64 %n.vec, %6, !dbg !72
  br i1 %cmp.n, label %.loopexit, label %scalar.ph.preheader, !dbg !72

scalar.ph.preheader:                              ; preds = %middle.block, %5
  %.ph = phi i64 [ 0, %5 ], [ %n.vec, %middle.block ]
  %.ph1 = phi i32 [ 0, %5 ], [ %10, %middle.block ]
  br label %scalar.ph, !dbg !72

scalar.ph:                                        ; preds = %scalar.ph.preheader, %scalar.ph
  %11 = phi i64 [ %16, %scalar.ph ], [ %.ph, %scalar.ph.preheader ]
  %12 = phi i32 [ %15, %scalar.ph ], [ %.ph1, %scalar.ph.preheader ]
    #dbg_value(i64 %11, !45, !DIExpression(), !70)
    #dbg_value(i32 %12, !44, !DIExpression(), !68)
  %13 = getelementptr inbounds i32, ptr %0, i64 %11, !dbg !75
  %14 = load i32, ptr %13, align 4, !dbg !75, !tbaa !28
  %15 = add nsw i32 %14, %12, !dbg !76
    #dbg_value(i32 %15, !44, !DIExpression(), !68)
  %16 = add nuw nsw i64 %11, 1, !dbg !74
    #dbg_value(i64 %16, !45, !DIExpression(), !70)
  %17 = icmp eq i64 %16, %6, !dbg !71
  br i1 %17, label %.loopexit, label %scalar.ph, !dbg !72, !llvm.loop !79

.loopexit:                                        ; preds = %scalar.ph, %middle.block
  %.lcssa = phi i32 [ %10, %middle.block ], [ %15, %scalar.ph ], !dbg !76
    #dbg_value(i32 %.lcssa, !66, !DIExpression(), !67)
  %18 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.1, i32 noundef %.lcssa), !dbg !73
  %19 = icmp sgt i32 %.lcssa, 0, !dbg !80
  %spec.select = select i1 %19, ptr @str.5, ptr @str
  br label %20

20:                                               ; preds = %.loopexit, %.thread
  %21 = phi ptr [ @str, %.thread ], [ %spec.select, %.loopexit ]
  %22 = tail call i32 @puts(ptr nonnull dereferenceable(1) %21), !dbg !82
  ret void, !dbg !83
}

; Function Attrs: nofree nounwind uwtable
define dso_local noundef i32 @main() local_unnamed_addr #0 !dbg !84 {
    #dbg_declare(ptr @__const.main.arr, !88, !DIExpression(), !93)
    #dbg_value(i32 5, !92, !DIExpression(), !94)
  %1 = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.6), !dbg !95
    #dbg_value(i32 5, !17, !DIExpression(), !96)
    #dbg_value(i32 0, !18, !DIExpression(), !98)
  br label %2, !dbg !99

2:                                                ; preds = %2, %0
  %3 = phi i64 [ 0, %0 ], [ %8, %2 ]
    #dbg_value(i64 %3, !18, !DIExpression(), !98)
  %4 = getelementptr inbounds [5 x i32], ptr @__const.main.arr, i64 0, i64 %3, !dbg !100
  %5 = load i32, ptr %4, align 4, !dbg !100, !tbaa !28
  %6 = trunc i64 %3 to i32, !dbg !101
  %7 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i32 noundef %6, i32 noundef %5) #5, !dbg !101
  %8 = add nuw nsw i64 %3, 1, !dbg !102
    #dbg_value(i64 %8, !18, !DIExpression(), !98)
  %9 = icmp eq i64 %8, 5, !dbg !103
  br i1 %9, label %10, label %2, !dbg !99, !llvm.loop !104

10:                                               ; preds = %2
    #dbg_value(i32 15, !66, !DIExpression(), !106)
  %11 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.1, i32 noundef 15) #5, !dbg !108
  %12 = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.5) #5, !dbg !109
  ret i32 0, !dbg !111
}

; Function Attrs: nofree nounwind
declare noundef i32 @puts(ptr nocapture noundef readonly) local_unnamed_addr #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.vector.reduce.add.v4i32(<4 x i32>) #4

attributes #0 = { nofree nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree norecurse nosync nounwind memory(argmem: read) uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nofree nounwind }
attributes #4 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "tmp/code.c", directory: "/home/aspasojevic@syrmia.com/llvm-project", checksumkind: CSK_MD5, checksum: "3b45f42c2f9b7fe7c3e730f0682234c8")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 8, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 1}
!8 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!9 = distinct !DISubprogram(name: "printArray", scope: !10, file: !10, line: 3, type: !11, scopeLine: 3, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !15)
!10 = !DIFile(filename: "./tmp/code.c", directory: "/home/aspasojevic@syrmia.com/llvm-project", checksumkind: CSK_MD5, checksum: "3b45f42c2f9b7fe7c3e730f0682234c8")
!11 = !DISubroutineType(types: !12)
!12 = !{null, !13, !14}
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!14 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!15 = !{!16, !17, !18}
!16 = !DILocalVariable(name: "arr", arg: 1, scope: !9, file: !10, line: 3, type: !13)
!17 = !DILocalVariable(name: "size", arg: 2, scope: !9, file: !10, line: 3, type: !14)
!18 = !DILocalVariable(name: "i", scope: !19, file: !10, line: 4, type: !14)
!19 = distinct !DILexicalBlock(scope: !9, file: !10, line: 4, column: 5)
!20 = !DILocation(line: 0, scope: !9)
!21 = !DILocation(line: 0, scope: !19)
!22 = !DILocation(line: 4, column: 23, scope: !23)
!23 = distinct !DILexicalBlock(scope: !19, file: !10, line: 4, column: 5)
!24 = !DILocation(line: 4, column: 5, scope: !19)
!25 = !DILocation(line: 7, column: 1, scope: !9)
!26 = !DILocation(line: 5, column: 39, scope: !27)
!27 = distinct !DILexicalBlock(scope: !23, file: !10, line: 4, column: 36)
!28 = !{!29, !29, i64 0}
!29 = !{!"int", !30, i64 0}
!30 = !{!"omnipotent char", !31, i64 0}
!31 = !{!"Simple C/C++ TBAA"}
!32 = !DILocation(line: 5, column: 9, scope: !27)
!33 = !DILocation(line: 4, column: 31, scope: !23)
!34 = distinct !{!34, !24, !35, !36, !37}
!35 = !DILocation(line: 6, column: 5, scope: !19)
!36 = !{!"llvm.loop.mustprogress"}
!37 = !{!"llvm.loop.unroll.disable"}
!38 = distinct !DISubprogram(name: "sumArray", scope: !10, file: !10, line: 9, type: !39, scopeLine: 9, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !41)
!39 = !DISubroutineType(types: !40)
!40 = !{!14, !13, !14}
!41 = !{!42, !43, !44, !45}
!42 = !DILocalVariable(name: "arr", arg: 1, scope: !38, file: !10, line: 9, type: !13)
!43 = !DILocalVariable(name: "size", arg: 2, scope: !38, file: !10, line: 9, type: !14)
!44 = !DILocalVariable(name: "sum", scope: !38, file: !10, line: 10, type: !14)
!45 = !DILocalVariable(name: "i", scope: !46, file: !10, line: 11, type: !14)
!46 = distinct !DILexicalBlock(scope: !38, file: !10, line: 11, column: 5)
!47 = !DILocation(line: 0, scope: !38)
!48 = !DILocation(line: 0, scope: !46)
!49 = !DILocation(line: 11, column: 23, scope: !50)
!50 = distinct !DILexicalBlock(scope: !46, file: !10, line: 11, column: 5)
!51 = !DILocation(line: 11, column: 5, scope: !46)
!52 = !DILocation(line: 11, column: 31, scope: !50)
!53 = !DILocation(line: 12, column: 16, scope: !54)
!54 = distinct !DILexicalBlock(scope: !50, file: !10, line: 11, column: 36)
!55 = !DILocation(line: 12, column: 13, scope: !54)
!56 = distinct !{!56, !51, !57, !36, !37, !58, !59}
!57 = !DILocation(line: 13, column: 5, scope: !46)
!58 = !{!"llvm.loop.isvectorized", i32 1}
!59 = !{!"llvm.loop.unroll.runtime.disable"}
!60 = !DILocation(line: 14, column: 5, scope: !38)
!61 = distinct !{!61, !51, !57, !36, !37, !58}
!62 = distinct !DISubprogram(name: "processData", scope: !10, file: !10, line: 17, type: !11, scopeLine: 17, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !63)
!63 = !{!64, !65, !66}
!64 = !DILocalVariable(name: "data", arg: 1, scope: !62, file: !10, line: 17, type: !13)
!65 = !DILocalVariable(name: "size", arg: 2, scope: !62, file: !10, line: 17, type: !14)
!66 = !DILocalVariable(name: "sum", scope: !62, file: !10, line: 18, type: !14)
!67 = !DILocation(line: 0, scope: !62)
!68 = !DILocation(line: 0, scope: !38, inlinedAt: !69)
!69 = distinct !DILocation(line: 18, column: 15, scope: !62)
!70 = !DILocation(line: 0, scope: !46, inlinedAt: !69)
!71 = !DILocation(line: 11, column: 23, scope: !50, inlinedAt: !69)
!72 = !DILocation(line: 11, column: 5, scope: !46, inlinedAt: !69)
!73 = !DILocation(line: 19, column: 5, scope: !62)
!74 = !DILocation(line: 11, column: 31, scope: !50, inlinedAt: !69)
!75 = !DILocation(line: 12, column: 16, scope: !54, inlinedAt: !69)
!76 = !DILocation(line: 12, column: 13, scope: !54, inlinedAt: !69)
!77 = distinct !{!77, !72, !78, !36, !37, !58, !59}
!78 = !DILocation(line: 13, column: 5, scope: !46, inlinedAt: !69)
!79 = distinct !{!79, !72, !78, !36, !37, !58}
!80 = !DILocation(line: 21, column: 13, scope: !81)
!81 = distinct !DILexicalBlock(scope: !62, file: !10, line: 21, column: 9)
!82 = !DILocation(line: 0, scope: !81)
!83 = !DILocation(line: 26, column: 1, scope: !62)
!84 = distinct !DISubprogram(name: "main", scope: !10, file: !10, line: 28, type: !85, scopeLine: 28, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !87)
!85 = !DISubroutineType(types: !86)
!86 = !{!14}
!87 = !{!88, !92}
!88 = !DILocalVariable(name: "arr", scope: !84, file: !10, line: 29, type: !89)
!89 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 160, elements: !90)
!90 = !{!91}
!91 = !DISubrange(count: 5)
!92 = !DILocalVariable(name: "arrSize", scope: !84, file: !10, line: 30, type: !14)
!93 = !DILocation(line: 29, column: 9, scope: !84)
!94 = !DILocation(line: 0, scope: !84)
!95 = !DILocation(line: 32, column: 5, scope: !84)
!96 = !DILocation(line: 0, scope: !9, inlinedAt: !97)
!97 = distinct !DILocation(line: 33, column: 5, scope: !84)
!98 = !DILocation(line: 0, scope: !19, inlinedAt: !97)
!99 = !DILocation(line: 4, column: 5, scope: !19, inlinedAt: !97)
!100 = !DILocation(line: 5, column: 39, scope: !27, inlinedAt: !97)
!101 = !DILocation(line: 5, column: 9, scope: !27, inlinedAt: !97)
!102 = !DILocation(line: 4, column: 31, scope: !23, inlinedAt: !97)
!103 = !DILocation(line: 4, column: 23, scope: !23, inlinedAt: !97)
!104 = distinct !{!104, !99, !105, !36, !37}
!105 = !DILocation(line: 6, column: 5, scope: !19, inlinedAt: !97)
!106 = !DILocation(line: 0, scope: !62, inlinedAt: !107)
!107 = distinct !DILocation(line: 35, column: 5, scope: !84)
!108 = !DILocation(line: 19, column: 5, scope: !62, inlinedAt: !107)
!109 = !DILocation(line: 22, column: 9, scope: !110, inlinedAt: !107)
!110 = distinct !DILexicalBlock(scope: !81, file: !10, line: 21, column: 18)
!111 = !DILocation(line: 37, column: 5, scope: !84)
