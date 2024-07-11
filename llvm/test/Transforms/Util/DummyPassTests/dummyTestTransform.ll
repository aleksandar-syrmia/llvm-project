; Test case for dummypasstransform

; ModuleID = './tmp/code.c'
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
define dso_local void @printArray(i32* nocapture noundef readonly %0, i32 noundef %1) local_unnamed_addr #0 !dbg !9 {
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32* %0, metadata !16, metadata !DIExpression()), !dbg !20
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32 %1, metadata !17, metadata !DIExpression()), !dbg !20
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32 0, metadata !18, metadata !DIExpression()), !dbg !21
  %3 = icmp sgt i32 %1, 0, !dbg !22
  br i1 %3, label %4, label %6, !dbg !24

4:                                                ; preds = %2
  %5 = zext i32 %1 to i64, !dbg !22
  br label %7, !dbg !24

6:                                                ; preds = %7, %2
  ret void, !dbg !25

7:                                                ; preds = %4, %7
  %8 = phi i64 [ 0, %4 ], [ %13, %7 ]
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i64 %8, metadata !18, metadata !DIExpression()), !dbg !21
  %9 = getelementptr inbounds i32, i32* %0, i64 %8, !dbg !26
  %10 = load i32, i32* %9, align 4, !dbg !26, !tbaa !28
  %11 = trunc i64 %8 to i32, !dbg !32
  %12 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i64 0, i64 0), i32 noundef %11, i32 noundef %10), !dbg !32
  %13 = add nuw nsw i64 %8, 1, !dbg !33
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i64 %13, metadata !18, metadata !DIExpression()), !dbg !21
  %14 = icmp eq i64 %13, %5, !dbg !22
  br i1 %14, label %6, label %7, !dbg !24, !llvm.loop !34
}

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
; CHECK-NOT: declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nofree nounwind
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #2

; Function Attrs: nofree norecurse nosync nounwind readonly uwtable
define dso_local i32 @sumArray(i32* nocapture noundef readonly %0, i32 noundef %1) local_unnamed_addr #3 !dbg !38 {
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32* %0, metadata !42, metadata !DIExpression()), !dbg !47
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32 %1, metadata !43, metadata !DIExpression()), !dbg !47
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32 0, metadata !44, metadata !DIExpression()), !dbg !47
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32 0, metadata !45, metadata !DIExpression()), !dbg !48
  %3 = icmp sgt i32 %1, 0, !dbg !49
  br i1 %3, label %4, label %6, !dbg !51

4:                                                ; preds = %2
  %5 = zext i32 %1 to i64, !dbg !49
  br label %8, !dbg !51

6:                                                ; preds = %8, %2
  %7 = phi i32 [ 0, %2 ], [ %13, %8 ], !dbg !47
  ret i32 %7, !dbg !52

8:                                                ; preds = %4, %8
  %9 = phi i64 [ 0, %4 ], [ %14, %8 ]
  %10 = phi i32 [ 0, %4 ], [ %13, %8 ]
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i64 %9, metadata !45, metadata !DIExpression()), !dbg !48
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32 %10, metadata !44, metadata !DIExpression()), !dbg !47
  %11 = getelementptr inbounds i32, i32* %0, i64 %9, !dbg !53
  %12 = load i32, i32* %11, align 4, !dbg !53, !tbaa !28
  %13 = add nsw i32 %12, %10, !dbg !55
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32 %13, metadata !44, metadata !DIExpression()), !dbg !47
  %14 = add nuw nsw i64 %9, 1, !dbg !56
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i64 %14, metadata !45, metadata !DIExpression()), !dbg !48
  %15 = icmp eq i64 %14, %5, !dbg !49
  br i1 %15, label %6, label %8, !dbg !51, !llvm.loop !57
}

; Function Attrs: nofree nounwind uwtable
define dso_local void @processData(i32* nocapture noundef readonly %0, i32 noundef %1) local_unnamed_addr #0 !dbg !59 {
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32* %0, metadata !61, metadata !DIExpression()), !dbg !64
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32 %1, metadata !62, metadata !DIExpression()), !dbg !64
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32* %0, metadata !42, metadata !DIExpression()), !dbg !65
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32 %1, metadata !43, metadata !DIExpression()), !dbg !65
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32 0, metadata !44, metadata !DIExpression()), !dbg !65
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32 0, metadata !45, metadata !DIExpression()), !dbg !67
  %3 = icmp sgt i32 %1, 0, !dbg !68
  br i1 %3, label %4, label %14, !dbg !69

4:                                                ; preds = %2
  %5 = zext i32 %1 to i64, !dbg !68
  br label %6, !dbg !69

6:                                                ; preds = %6, %4
  %7 = phi i64 [ 0, %4 ], [ %12, %6 ]
  %8 = phi i32 [ 0, %4 ], [ %11, %6 ]
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i64 %7, metadata !45, metadata !DIExpression()), !dbg !67
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32 %8, metadata !44, metadata !DIExpression()), !dbg !65
  %9 = getelementptr inbounds i32, i32* %0, i64 %7, !dbg !70
  %10 = load i32, i32* %9, align 4, !dbg !70, !tbaa !28
  %11 = add nsw i32 %10, %8, !dbg !71
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32 %11, metadata !44, metadata !DIExpression()), !dbg !65
  %12 = add nuw nsw i64 %7, 1, !dbg !72
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i64 %12, metadata !45, metadata !DIExpression()), !dbg !67
  %13 = icmp eq i64 %12, %5, !dbg !68
  br i1 %13, label %14, label %6, !dbg !69, !llvm.loop !73

14:                                               ; preds = %6, %2
  %15 = phi i32 [ 0, %2 ], [ %11, %6 ], !dbg !65
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32 %15, metadata !63, metadata !DIExpression()), !dbg !64
  %16 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([17 x i8], [17 x i8]* @.str.1, i64 0, i64 0), i32 noundef %15), !dbg !75
  %17 = icmp sgt i32 %15, 0, !dbg !76
  %18 = select i1 %17, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @str.5, i64 0, i64 0), i8* getelementptr inbounds ([27 x i8], [27 x i8]* @str, i64 0, i64 0)
  %19 = call i32 @puts(i8* nonnull dereferenceable(1) %18), !dbg !78
  ret void, !dbg !79
}

; Function Attrs: nofree nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #0 !dbg !80 {
  ; CHECK-NOT: call void @llvm.dbg.declare(metadata [5 x i32]* @__const.main.arr, metadata !84, metadata !DIExpression()), !dbg !89
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32 5, metadata !88, metadata !DIExpression()), !dbg !90
  %1 = call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([16 x i8], [16 x i8]* @str.6, i64 0, i64 0)), !dbg !91
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32 5, metadata !17, metadata !DIExpression()) #6, !dbg !92
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32 0, metadata !18, metadata !DIExpression()) #6, !dbg !94
  br label %2, !dbg !95

2:                                                ; preds = %2, %0
  %3 = phi i64 [ 0, %0 ], [ %8, %2 ]
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i64 %3, metadata !18, metadata !DIExpression()) #6, !dbg !94
  %4 = getelementptr inbounds [5 x i32], [5 x i32]* @__const.main.arr, i64 0, i64 %3, !dbg !96
  %5 = load i32, i32* %4, align 4, !dbg !96, !tbaa !28
  %6 = trunc i64 %3 to i32, !dbg !97
  %7 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i64 0, i64 0), i32 noundef %6, i32 noundef %5) #6, !dbg !97
  %8 = add nuw nsw i64 %3, 1, !dbg !98
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i64 %8, metadata !18, metadata !DIExpression()) #6, !dbg !94
  %9 = icmp eq i64 %8, 5, !dbg !99
  br i1 %9, label %10, label %2, !dbg !95, !llvm.loop !100

10:                                               ; preds = %2
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32 undef, metadata !45, metadata !DIExpression()), !dbg !102
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32 undef, metadata !44, metadata !DIExpression()), !dbg !105
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32 undef, metadata !44, metadata !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_plus, DW_OP_stack_value)), !dbg !105
  ; CHECK-NOT: call void @llvm.dbg.value(metadata i32 15, metadata !63, metadata !DIExpression()) #6, !dbg !106
  %11 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([17 x i8], [17 x i8]* @.str.1, i64 0, i64 0), i32 noundef 15) #6, !dbg !107
  %12 = call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @str.5, i64 0, i64 0)) #6, !dbg !108
  ret i32 0, !dbg !110
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
; CHECK-NOT: declare void @llvm.dbg.value(metadata, metadata, metadata) #4

; Function Attrs: nofree nounwind
declare noundef i32 @puts(i8* nocapture noundef readonly) local_unnamed_addr #5

attributes #0 = { nofree nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nofree nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nofree norecurse nosync nounwind readonly uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #5 = { nofree nounwind }
attributes #6 = { nounwind }

; CHECK-NOT: !llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "tmp/code.c", directory: "/home/aspasojevic@syrmia.com/llvm-project", checksumkind: CSK_MD5, checksum: "3b45f42c2f9b7fe7c3e730f0682234c8")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 7, !"PIC Level", i32 2}
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
!52 = !DILocation(line: 14, column: 5, scope: !38)
!53 = !DILocation(line: 12, column: 16, scope: !54)
!54 = distinct !DILexicalBlock(scope: !50, file: !10, line: 11, column: 36)
!55 = !DILocation(line: 12, column: 13, scope: !54)
!56 = !DILocation(line: 11, column: 31, scope: !50)
!57 = distinct !{!57, !51, !58, !36, !37}
!58 = !DILocation(line: 13, column: 5, scope: !46)
!59 = distinct !DISubprogram(name: "processData", scope: !10, file: !10, line: 17, type: !11, scopeLine: 17, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !60)
!60 = !{!61, !62, !63}
!61 = !DILocalVariable(name: "data", arg: 1, scope: !59, file: !10, line: 17, type: !13)
!62 = !DILocalVariable(name: "size", arg: 2, scope: !59, file: !10, line: 17, type: !14)
!63 = !DILocalVariable(name: "sum", scope: !59, file: !10, line: 18, type: !14)
!64 = !DILocation(line: 0, scope: !59)
!65 = !DILocation(line: 0, scope: !38, inlinedAt: !66)
!66 = distinct !DILocation(line: 18, column: 15, scope: !59)
!67 = !DILocation(line: 0, scope: !46, inlinedAt: !66)
!68 = !DILocation(line: 11, column: 23, scope: !50, inlinedAt: !66)
!69 = !DILocation(line: 11, column: 5, scope: !46, inlinedAt: !66)
!70 = !DILocation(line: 12, column: 16, scope: !54, inlinedAt: !66)
!71 = !DILocation(line: 12, column: 13, scope: !54, inlinedAt: !66)
!72 = !DILocation(line: 11, column: 31, scope: !50, inlinedAt: !66)
!73 = distinct !{!73, !69, !74, !36, !37}
!74 = !DILocation(line: 13, column: 5, scope: !46, inlinedAt: !66)
!75 = !DILocation(line: 19, column: 5, scope: !59)
!76 = !DILocation(line: 21, column: 13, scope: !77)
!77 = distinct !DILexicalBlock(scope: !59, file: !10, line: 21, column: 9)
!78 = !DILocation(line: 0, scope: !77)
!79 = !DILocation(line: 26, column: 1, scope: !59)
!80 = distinct !DISubprogram(name: "main", scope: !10, file: !10, line: 28, type: !81, scopeLine: 28, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !83)
!81 = !DISubroutineType(types: !82)
!82 = !{!14}
!83 = !{!84, !88}
!84 = !DILocalVariable(name: "arr", scope: !80, file: !10, line: 29, type: !85)
!85 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 160, elements: !86)
!86 = !{!87}
!87 = !DISubrange(count: 5)
!88 = !DILocalVariable(name: "arrSize", scope: !80, file: !10, line: 30, type: !14)
!89 = !DILocation(line: 29, column: 9, scope: !80)
!90 = !DILocation(line: 0, scope: !80)
!91 = !DILocation(line: 32, column: 5, scope: !80)
!92 = !DILocation(line: 0, scope: !9, inlinedAt: !93)
!93 = distinct !DILocation(line: 33, column: 5, scope: !80)
!94 = !DILocation(line: 0, scope: !19, inlinedAt: !93)
!95 = !DILocation(line: 4, column: 5, scope: !19, inlinedAt: !93)
!96 = !DILocation(line: 5, column: 39, scope: !27, inlinedAt: !93)
!97 = !DILocation(line: 5, column: 9, scope: !27, inlinedAt: !93)
!98 = !DILocation(line: 4, column: 31, scope: !23, inlinedAt: !93)
!99 = !DILocation(line: 4, column: 23, scope: !23, inlinedAt: !93)
!100 = distinct !{!100, !95, !101, !36, !37}
!101 = !DILocation(line: 6, column: 5, scope: !19, inlinedAt: !93)
!102 = !DILocation(line: 0, scope: !46, inlinedAt: !103)
!103 = distinct !DILocation(line: 18, column: 15, scope: !59, inlinedAt: !104)
!104 = distinct !DILocation(line: 35, column: 5, scope: !80)
!105 = !DILocation(line: 0, scope: !38, inlinedAt: !103)
!106 = !DILocation(line: 0, scope: !59, inlinedAt: !104)
!107 = !DILocation(line: 19, column: 5, scope: !59, inlinedAt: !104)
!108 = !DILocation(line: 22, column: 9, scope: !109, inlinedAt: !104)
!109 = distinct !DILexicalBlock(scope: !77, file: !10, line: 21, column: 18)
!110 = !DILocation(line: 37, column: 5, scope: !80)











; RUN: opt -S -O2 %s 2>&1 | FileCheck %s