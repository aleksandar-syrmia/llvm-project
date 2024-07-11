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
  %3 = icmp sgt i32 %1, 0, !dbg !20
  br i1 %3, label %4, label %.loopexit, !dbg !22

4:                                                ; preds = %2
  %5 = zext nneg i32 %1 to i64, !dbg !20
  br label %6, !dbg !22

.loopexit:                                        ; preds = %6, %2
  ret void, !dbg !23

6:                                                ; preds = %6, %4
  %7 = phi i64 [ 0, %4 ], [ %12, %6 ]
  %8 = getelementptr inbounds i32, ptr %0, i64 %7, !dbg !24
  %9 = load i32, ptr %8, align 4, !dbg !24, !tbaa !26
  %10 = trunc i64 %7 to i32, !dbg !30
  %11 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i32 noundef %10, i32 noundef %9), !dbg !30
  %12 = add nuw nsw i64 %7, 1, !dbg !31
  %13 = icmp eq i64 %12, %5, !dbg !20
  br i1 %13, label %.loopexit, label %6, !dbg !22, !llvm.loop !32
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr nocapture noundef readonly, ...) local_unnamed_addr #1

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read) uwtable
define dso_local i32 @sumArray(ptr nocapture noundef readonly %0, i32 noundef %1) local_unnamed_addr #2 !dbg !36 {
  %3 = icmp sgt i32 %1, 0, !dbg !45
  br i1 %3, label %4, label %.loopexit, !dbg !47

4:                                                ; preds = %2
  %5 = zext nneg i32 %1 to i64, !dbg !45
  %min.iters.check = icmp ult i32 %1, 4, !dbg !47
  br i1 %min.iters.check, label %scalar.ph.preheader, label %vector.ph, !dbg !47

scalar.ph.preheader:                              ; preds = %middle.block, %4
  %.ph = phi i64 [ 0, %4 ], [ %n.vec, %middle.block ]
  %.ph1 = phi i32 [ 0, %4 ], [ %9, %middle.block ]
  br label %scalar.ph, !dbg !47

vector.ph:                                        ; preds = %4
  %n.vec = and i64 %5, 2147483644, !dbg !47
  br label %vector.body, !dbg !47

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ], !dbg !48
  %vec.phi = phi <4 x i32> [ zeroinitializer, %vector.ph ], [ %7, %vector.body ]
  %6 = getelementptr inbounds i32, ptr %0, i64 %index, !dbg !49
  %wide.load = load <4 x i32>, ptr %6, align 4, !dbg !49, !tbaa !26
  %7 = add <4 x i32> %wide.load, %vec.phi, !dbg !51
  %index.next = add nuw i64 %index, 4, !dbg !48
  %8 = icmp eq i64 %index.next, %n.vec, !dbg !48
  br i1 %8, label %middle.block, label %vector.body, !dbg !48, !llvm.loop !52

middle.block:                                     ; preds = %vector.body
  %9 = tail call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %7), !dbg !47
  %cmp.n = icmp eq i64 %n.vec, %5, !dbg !47
  br i1 %cmp.n, label %.loopexit, label %scalar.ph.preheader, !dbg !47

.loopexit:                                        ; preds = %scalar.ph, %middle.block, %2
  %10 = phi i32 [ 0, %2 ], [ %9, %middle.block ], [ %15, %scalar.ph ], !dbg !56
  ret i32 %10, !dbg !57

scalar.ph:                                        ; preds = %scalar.ph.preheader, %scalar.ph
  %11 = phi i64 [ %16, %scalar.ph ], [ %.ph, %scalar.ph.preheader ]
  %12 = phi i32 [ %15, %scalar.ph ], [ %.ph1, %scalar.ph.preheader ]
  %13 = getelementptr inbounds i32, ptr %0, i64 %11, !dbg !49
  %14 = load i32, ptr %13, align 4, !dbg !49, !tbaa !26
  %15 = add nsw i32 %14, %12, !dbg !51
  %16 = add nuw nsw i64 %11, 1, !dbg !48
  %17 = icmp eq i64 %16, %5, !dbg !45
  br i1 %17, label %.loopexit, label %scalar.ph, !dbg !47, !llvm.loop !58
}

; Function Attrs: nofree nounwind uwtable
define dso_local void @processData(ptr nocapture noundef readonly %0, i32 noundef %1) local_unnamed_addr #0 !dbg !59 {
  %3 = icmp sgt i32 %1, 0, !dbg !64
  br i1 %3, label %5, label %.thread, !dbg !66

.thread:                                          ; preds = %2
  %4 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.1, i32 noundef 0), !dbg !67
  br label %20

5:                                                ; preds = %2
  %6 = zext nneg i32 %1 to i64, !dbg !64
  %min.iters.check = icmp ult i32 %1, 4, !dbg !66
  br i1 %min.iters.check, label %scalar.ph.preheader, label %vector.ph, !dbg !66

vector.ph:                                        ; preds = %5
  %n.vec = and i64 %6, 2147483644, !dbg !66
  br label %vector.body, !dbg !66

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ], !dbg !68
  %vec.phi = phi <4 x i32> [ zeroinitializer, %vector.ph ], [ %8, %vector.body ]
  %7 = getelementptr inbounds i32, ptr %0, i64 %index, !dbg !69
  %wide.load = load <4 x i32>, ptr %7, align 4, !dbg !69, !tbaa !26
  %8 = add <4 x i32> %wide.load, %vec.phi, !dbg !70
  %index.next = add nuw i64 %index, 4, !dbg !68
  %9 = icmp eq i64 %index.next, %n.vec, !dbg !68
  br i1 %9, label %middle.block, label %vector.body, !dbg !68, !llvm.loop !71

middle.block:                                     ; preds = %vector.body
  %10 = tail call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %8), !dbg !66
  %cmp.n = icmp eq i64 %n.vec, %6, !dbg !66
  br i1 %cmp.n, label %.loopexit, label %scalar.ph.preheader, !dbg !66

scalar.ph.preheader:                              ; preds = %middle.block, %5
  %.ph = phi i64 [ 0, %5 ], [ %n.vec, %middle.block ]
  %.ph1 = phi i32 [ 0, %5 ], [ %10, %middle.block ]
  br label %scalar.ph, !dbg !66

scalar.ph:                                        ; preds = %scalar.ph.preheader, %scalar.ph
  %11 = phi i64 [ %16, %scalar.ph ], [ %.ph, %scalar.ph.preheader ]
  %12 = phi i32 [ %15, %scalar.ph ], [ %.ph1, %scalar.ph.preheader ]
  %13 = getelementptr inbounds i32, ptr %0, i64 %11, !dbg !69
  %14 = load i32, ptr %13, align 4, !dbg !69, !tbaa !26
  %15 = add nsw i32 %14, %12, !dbg !70
  %16 = add nuw nsw i64 %11, 1, !dbg !68
  %17 = icmp eq i64 %16, %6, !dbg !64
  br i1 %17, label %.loopexit, label %scalar.ph, !dbg !66, !llvm.loop !73

.loopexit:                                        ; preds = %scalar.ph, %middle.block
  %.lcssa = phi i32 [ %10, %middle.block ], [ %15, %scalar.ph ], !dbg !70
  %18 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.1, i32 noundef %.lcssa), !dbg !67
  %19 = icmp sgt i32 %.lcssa, 0, !dbg !74
  %spec.select = select i1 %19, ptr @str.5, ptr @str
  br label %20

20:                                               ; preds = %.loopexit, %.thread
  %21 = phi ptr [ @str, %.thread ], [ %spec.select, %.loopexit ]
  %22 = tail call i32 @puts(ptr nonnull dereferenceable(1) %21), !dbg !76
  ret void, !dbg !77
}

; Function Attrs: nofree nounwind uwtable
define dso_local noundef i32 @main() local_unnamed_addr #0 !dbg !78 {
  %1 = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.6), !dbg !87
  br label %2, !dbg !88

2:                                                ; preds = %2, %0
  %3 = phi i64 [ 0, %0 ], [ %8, %2 ]
  %4 = getelementptr inbounds [5 x i32], ptr @__const.main.arr, i64 0, i64 %3, !dbg !90
  %5 = load i32, ptr %4, align 4, !dbg !90, !tbaa !26
  %6 = trunc i64 %3 to i32, !dbg !91
  %7 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i32 noundef %6, i32 noundef %5) #5, !dbg !91
  %8 = add nuw nsw i64 %3, 1, !dbg !92
  %9 = icmp eq i64 %8, 5, !dbg !93
  br i1 %9, label %10, label %2, !dbg !88, !llvm.loop !94

10:                                               ; preds = %2
  %11 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.1, i32 noundef 15) #5, !dbg !96
  %12 = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.5) #5, !dbg !98
  ret i32 0, !dbg !100
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
!20 = !DILocation(line: 4, column: 23, scope: !21)
!21 = distinct !DILexicalBlock(scope: !19, file: !10, line: 4, column: 5)
!22 = !DILocation(line: 4, column: 5, scope: !19)
!23 = !DILocation(line: 7, column: 1, scope: !9)
!24 = !DILocation(line: 5, column: 39, scope: !25)
!25 = distinct !DILexicalBlock(scope: !21, file: !10, line: 4, column: 36)
!26 = !{!27, !27, i64 0}
!27 = !{!"int", !28, i64 0}
!28 = !{!"omnipotent char", !29, i64 0}
!29 = !{!"Simple C/C++ TBAA"}
!30 = !DILocation(line: 5, column: 9, scope: !25)
!31 = !DILocation(line: 4, column: 31, scope: !21)
!32 = distinct !{!32, !22, !33, !34, !35}
!33 = !DILocation(line: 6, column: 5, scope: !19)
!34 = !{!"llvm.loop.mustprogress"}
!35 = !{!"llvm.loop.unroll.disable"}
!36 = distinct !DISubprogram(name: "sumArray", scope: !10, file: !10, line: 9, type: !37, scopeLine: 9, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !39)
!37 = !DISubroutineType(types: !38)
!38 = !{!14, !13, !14}
!39 = !{!40, !41, !42, !43}
!40 = !DILocalVariable(name: "arr", arg: 1, scope: !36, file: !10, line: 9, type: !13)
!41 = !DILocalVariable(name: "size", arg: 2, scope: !36, file: !10, line: 9, type: !14)
!42 = !DILocalVariable(name: "sum", scope: !36, file: !10, line: 10, type: !14)
!43 = !DILocalVariable(name: "i", scope: !44, file: !10, line: 11, type: !14)
!44 = distinct !DILexicalBlock(scope: !36, file: !10, line: 11, column: 5)
!45 = !DILocation(line: 11, column: 23, scope: !46)
!46 = distinct !DILexicalBlock(scope: !44, file: !10, line: 11, column: 5)
!47 = !DILocation(line: 11, column: 5, scope: !44)
!48 = !DILocation(line: 11, column: 31, scope: !46)
!49 = !DILocation(line: 12, column: 16, scope: !50)
!50 = distinct !DILexicalBlock(scope: !46, file: !10, line: 11, column: 36)
!51 = !DILocation(line: 12, column: 13, scope: !50)
!52 = distinct !{!52, !47, !53, !34, !35, !54, !55}
!53 = !DILocation(line: 13, column: 5, scope: !44)
!54 = !{!"llvm.loop.isvectorized", i32 1}
!55 = !{!"llvm.loop.unroll.runtime.disable"}
!56 = !DILocation(line: 0, scope: !36)
!57 = !DILocation(line: 14, column: 5, scope: !36)
!58 = distinct !{!58, !47, !53, !34, !35, !54}
!59 = distinct !DISubprogram(name: "processData", scope: !10, file: !10, line: 17, type: !11, scopeLine: 17, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !60)
!60 = !{!61, !62, !63}
!61 = !DILocalVariable(name: "data", arg: 1, scope: !59, file: !10, line: 17, type: !13)
!62 = !DILocalVariable(name: "size", arg: 2, scope: !59, file: !10, line: 17, type: !14)
!63 = !DILocalVariable(name: "sum", scope: !59, file: !10, line: 18, type: !14)
!64 = !DILocation(line: 11, column: 23, scope: !46, inlinedAt: !65)
!65 = distinct !DILocation(line: 18, column: 15, scope: !59)
!66 = !DILocation(line: 11, column: 5, scope: !44, inlinedAt: !65)
!67 = !DILocation(line: 19, column: 5, scope: !59)
!68 = !DILocation(line: 11, column: 31, scope: !46, inlinedAt: !65)
!69 = !DILocation(line: 12, column: 16, scope: !50, inlinedAt: !65)
!70 = !DILocation(line: 12, column: 13, scope: !50, inlinedAt: !65)
!71 = distinct !{!71, !66, !72, !34, !35, !54, !55}
!72 = !DILocation(line: 13, column: 5, scope: !44, inlinedAt: !65)
!73 = distinct !{!73, !66, !72, !34, !35, !54}
!74 = !DILocation(line: 21, column: 13, scope: !75)
!75 = distinct !DILexicalBlock(scope: !59, file: !10, line: 21, column: 9)
!76 = !DILocation(line: 0, scope: !75)
!77 = !DILocation(line: 26, column: 1, scope: !59)
!78 = distinct !DISubprogram(name: "main", scope: !10, file: !10, line: 28, type: !79, scopeLine: 28, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !81)
!79 = !DISubroutineType(types: !80)
!80 = !{!14}
!81 = !{!82, !86}
!82 = !DILocalVariable(name: "arr", scope: !78, file: !10, line: 29, type: !83)
!83 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 160, elements: !84)
!84 = !{!85}
!85 = !DISubrange(count: 5)
!86 = !DILocalVariable(name: "arrSize", scope: !78, file: !10, line: 30, type: !14)
!87 = !DILocation(line: 32, column: 5, scope: !78)
!88 = !DILocation(line: 4, column: 5, scope: !19, inlinedAt: !89)
!89 = distinct !DILocation(line: 33, column: 5, scope: !78)
!90 = !DILocation(line: 5, column: 39, scope: !25, inlinedAt: !89)
!91 = !DILocation(line: 5, column: 9, scope: !25, inlinedAt: !89)
!92 = !DILocation(line: 4, column: 31, scope: !21, inlinedAt: !89)
!93 = !DILocation(line: 4, column: 23, scope: !21, inlinedAt: !89)
!94 = distinct !{!94, !88, !95, !34, !35}
!95 = !DILocation(line: 6, column: 5, scope: !19, inlinedAt: !89)
!96 = !DILocation(line: 19, column: 5, scope: !59, inlinedAt: !97)
!97 = distinct !DILocation(line: 35, column: 5, scope: !78)
!98 = !DILocation(line: 22, column: 9, scope: !99, inlinedAt: !97)
!99 = distinct !DILexicalBlock(scope: !75, file: !10, line: 21, column: 18)
!100 = !DILocation(line: 37, column: 5, scope: !78)
