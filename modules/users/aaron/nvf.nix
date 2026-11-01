{ inputs, ... }: {
  den.aspects.aaron.provides.nvf.homeManager = {
    imports = [ inputs.nvf.homeManagerModules.default ];
    
    programs.nvf = {
      enable = true;
      settings = {
        vim.lsp = {
          enable = true;
        };
      };
    };
  };
}