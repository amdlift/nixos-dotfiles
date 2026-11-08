{ den, ... }: {
  den.aspects.danya._.minecraft-server = {
    includes = [ den.aspects.minecraft-server ];

    nixos = { pkgs, ... }: {
      services.minecraft-servers = {
        servers.wizardcraft = {
          enable = true;
          package = pkgs.neoforgeServers.neoforge-1_21_1;

          serverProperties = {
            gamemode = "survival";
            difficulty = "easy";
            white-list = true;
            enforce-whitelist = true;
          };

          symlinks = {
            mods = pkgs.linkFarmFromDrvs "mods" (
              builtins.attrValues {

                # Performance

                Distant-Horizons = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/uCdwusMi/versions/TGgEbP9A/DistantHorizons-3.3.4-26.3-fabric-neoforge.jar";
                  sha512 = "0b90b1b08d99974bfc3c8e86b2ceb252e2f91715ed66b925004c28335fb44e1bddbbb6b8043e4d4d53c87ed247789cd1788b1ba4e3f4394efe154e0c59cff236";
                };
                FerritCore = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/uXXizFIs/versions/x7kQWVju/ferritecore-7.0.3-neoforge.jar";
                  sha512 = "19af89a2075bb10a63884fa853ebf84b02c79dc3242430ecdad056fd764fdcde367a7303276b329df01b0736e2ef264c5d80c7dc92c6aebd244f556a230bb417";
                };
                Lithium = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/DDUrRVCA/lithium-neoforge-0.15.4%2Bmc1.21.1.jar";
                  sha512 = "2735da2088b88a8bdcd4ad02a2b6fffbfd3925557cefd4fa54b5477dfb9e582ea7f521300c060f57dff1325dd21bff276b7333363ad3371ed6893e3de9eca9cd";
                };

                # Libraries

                Aces-Spell-Utils = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/7Jy4rK9m/versions/TqHb6wO4/aces_spell_utils-1.2.7.5-1.21.1.jar";
                  sha512 = "b521273ca9500caee79b5b8a71aafaca2ceeb110dbe8e5ccde9b5f5c80c36838bcf730887a35b030c864521696fba539d3bd6762f69e82c4ee7e12707f8c85af";
                };
                AzureLib = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/7zlUOZvb/versions/R8LC8RYk/azurelib-neo-1.21.1-3.2.7.jar";
                  sha512 = "80d81bbcaf9d4296263b48bf0df8272a34cf79f61552b67f1ed17246dccfb0f0f5ae9bf2a259143ac5ed0e3bccf53c5757b2a2e41c22276e2727d702f6985e99";
                };
                Curios-API = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/vvuO3ImH/versions/yohfFbgD/curios-neoforge-9.5.1%2B1.21.1.jar";
                  sha512 = "5981a267686b744e7e3c227f78cbcd5267c14ac6979a28e814695f4589273998563147207fef4a5cdb7cdbdc39797cd95d9e4abadb55869f18e02a38d0654ae5";
                };
                Lionfish-API = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/FoVacERa/versions/fTRMVgyZ/lionfishapi-3.1.jar";
                  sha512 = "fdd90f19d0424c3a837111291d6ac1547d62cbcedd43b74d3a8946912f9c5212a5ea239a6969eccf678289bcb77cbb9a937db01fdaf60e57826f9a99893d19cb";
                };

                # Content

                Irons-Spells-n-Spellbooks = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/s4OWxYQQ/versions/slKLosTb/irons_spellbooks-1.21.1-3.16.3.jar";
                  sha512 = "fd782f98c6c59b193c4832f33775291d2a7e639e1e23dd47510bfb494d99d182bec1253566b9394f96c733a0d0108be34bd729614b82dc29e55e096fdeb96f5b";
                };
                Cataclysm = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/46KJle7n/versions/PsPYpoCC/L_Ender%27s%20Cataclysm%201.21.1-3.33.jar";
                  sha512 = "289f6e8364a6e432f34803a47cff8381899a1df0fdc675170323b43fd1c09579b1320d8b4e0de5df65c609b738d450c13c89e240d6d79f607888da26b7724947";
                };
                Cataclysm-Spellbooks = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/3FEg0A8D/versions/7fmcTGwb/cataclysm_spellbooks-1.1.15-1.21.jar";
                  sha512 = "358e87690ea1b1a341d6edfe3b0ec145acc0e668a4872e32f3c0530b466303f645fd5a572af27fca740e5ce1b9bc4c74c6e0b2ca31b08588c36dac4f46e4fa6c";
                };
                Farmers-Delight = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/R2OftAxM/versions/XTVZDOol/FarmersDelight-1.21.1-1.3.4.jar";
                  sha512 = "1f6f8796469f747cff36f477b4f589a3d69613882399f9ee7f86db36c7bca9aa4828731f43db15dc6c7f5a4c1bbe3d4092a232e8cef010b09cec0581848fda90";
                };
                Farmers-Spell-n-Spell-Book = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/UWV8H4F4/versions/4F8DZu21/farmers-spell-n-spellbook-1.0.7.1-1.21.1.jar";
                  sha512 = "99107b3b2a1c8f1a120ebbe427ef3a7e83a0b19d2548b63887d2b9c38ff9158a8bfacb587dfeb7f3ccf082eb87c6bff804bf5bb05970ad5f2a20a32d4234d8bf";
                };

                # QOL

                JEI = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/u6dRKJwZ/versions/1vC6z8wV/jei-1.21.1-neoforge-19.70.0.469.jar";
                  sha512 = "65e9ed5d032e6f284dbdc7f5a41ca43f35ffb9e086419105ee6b360333b1349dc5967bf6ca250f8f02adf73326318945b6c4e57624c0e0a09fc566731e328bc1";
                };
                Waystones = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/LOpKHB2A/versions/6Z6MQ6os/waystones-neoforge-1.21.1-21.1.46.jar";
                  sha512 = "ca90b58d884d4bc2b08a870484ae7ede397e71d31eaaf01ff2603ad498d584763e099c2094e57031522385339705d2c011ed4910bf36efae688e64935b49ece9";
                };
              }
            );
          };

          whitelist = {
            amdlift = "20d4645e-439a-44af-8694-ef5d66fe0832";
            amberlargo = "d1f10dd3-7d33-46e4-9bfb-c4da23d25a1a";
          };

          operators = {
            amdlift = "20d4645e-439a-44af-8694-ef5d66fe0832";
          };
        };
      };
    };
  };
}
