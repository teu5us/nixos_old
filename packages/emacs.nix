self: super: {
  tree-sitter-grammars-combined = super.symlinkJoin {
    name = "tree-sitter-grammars-combined";
    paths = self.tree-sitter.allGrammars;
  };
  emacsPackagesFor = emacs: (
    (super.emacsPackagesFor emacs).overrideScope' (self': super':
      super' // rec {
        tree-sitter-langs = super'.tree-sitter-langs.overrideAttrs (oa: {
          postPatch = oa.postPatch or "" + ''
            substituteInPlace ./tree-sitter-langs-build.el \
              --replace "tree-sitter-langs-grammar-dir tree-sitter-langs--dir" "tree-sitter-langs-grammar-dir \"${tree-sitter-grammars-combined}/langs\""
          '';
        });
      }
    )
  );
}
