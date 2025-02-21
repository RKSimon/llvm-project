set(LLVM_LINK_COMPONENTS
  Core
  SelectionDAG
  Support
  TargetParser
  )

add_clang_unittest(ClangCodeGenTests
  BufferSourceTest.cpp
  CodeGenExternalTest.cpp
  TBAAMetadataTest.cpp
  CheckTargetFeaturesTest.cpp
  )

clang_target_link_libraries(ClangCodeGenTests
  PRIVATE
  clangAST
  clangBasic
  clangCodeGen
  clangFrontend
  clangLex
  clangParse
  clangSerialization
  )
