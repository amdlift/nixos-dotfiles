{ den, ... }: {
  den.aspects.danya._.minecraft-server = {
    includes = [
      den.aspects.minecraft-server

      (den._.unfree [
        "neoforge"
      ])
    ];

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
                  url = "https://cdn.modrinth.com/data/uCdwusMi/versions/9w34y8ai/DistantHorizons-3.3.3-1.21.1-fabric-neoforge.jar";
                  sha512 = "d14b32d3fd143a06514d6ad388eee11e9d657c84e1a937aaf8d033b1137fb43ef8b05cff1011a994cc42f3106823c51234f8bc18d72bb05bc317a20ea83c50ed";
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
                Balm = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/MBAkmtvl/versions/gMedgtzL/balm-neoforge-1.21.1-21.0.67.jar";
                  sha512 = "ad4f4df829b1195446486df818c2c1f0bf6738cb1b30cfdbf9eae4855ce62a66b00f2dc5e0a87409f25ce4eba9bd5c94e1b10d1940af451d5ef7dd7f4b3d8ebd";
                };
                Curios-API = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/vvuO3ImH/versions/yohfFbgD/curios-neoforge-9.5.1%2B1.21.1.jar";
                  sha512 = "5981a267686b744e7e3c227f78cbcd5267c14ac6979a28e814695f4589273998563147207fef4a5cdb7cdbdc39797cd95d9e4abadb55869f18e02a38d0654ae5";
                };
                GeckoLib = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/8BmcQJ2H/versions/Grwn5rUB/geckolib-neoforge-1.21.1-4.9.3.jar";
                  sha512 = "8dfa5f8c57224a5e34e5098367ea9819ca6dc9c11357cd3062c16da3455c8bd1a483098af7383debc4b9ce8e4d7ab3fdc799b415644eb829da83eb72a7335dfd";
                };
                Irons-Lib = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/9nfaJPtX/versions/dgH7P81J/irons_lib-1.21.1-2.3.0.jar";
                  sha512 = "74c609a583af1547c36ad39a7f89074a221f106fad5a246810d4921f91d0fc2df5660ef75f47f33e5f546cc51147d78ecbcff883da4a53f24002311697d0a99b";
                };
                Lionfish-API = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/FoVacERa/versions/fTRMVgyZ/lionfishapi-3.1.jar";
                  sha512 = "fdd90f19d0424c3a837111291d6ac1547d62cbcedd43b74d3a8946912f9c5212a5ea239a6969eccf678289bcb77cbb9a937db01fdaf60e57826f9a99893d19cb";
                };
                Patchouli = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/nU0bVIaL/versions/BIogJv2D/Patchouli-1.21.1-93-NEOFORGE.jar";
                  sha512 = "0b5c172db9a6eeecb5ca44b359a83548c3a60be7ff313959acdfc1e5b8039736c18e57e947d435b52d06da31159d2d02ea36e5742668dbc826308a4c99e4039f";
                };
                Placebo = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/tCkE8p2N/versions/B5zbSVlT/Placebo-1.21.1-9.9.4.jar";
                  sha512 = "4f3a9c5974132f3638c262c56b0c2886df2bc58027c961aa11d06d0ae2e608b63f24f949b2f8c240989e2a1bfe303fd237c5f2d49269453ad6c2ff1f85f2c648";
                };
                playerAnimator = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/gedNE4y2/versions/HJZB6bmA/player-animation-lib-forge-2.0.4%2B1.21.1.jar";
                  sha512 = "fc00450fb6c95ec1779021bdc726122dacb5915c6baddaacc981cd221b01b8db35f2a0dfde5d6fa6766d877266dc82f58854f571ea53cc5c4d468b80e1548a5f";
                };
                YUNGs-API = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/Ua7DFN59/versions/2prKITKh/YungsApi-1.21.1-NeoForge-5.1.9.jar";
                  sha512 = "7e3cf0b429e8a1c51dca094c2d8eabf12245bb42cbcd8b6e3e54959f931bef93201b81a08d200b417059aaa438e8eb445c3978a09568597bfb588199b7775967";
                };

                # Content

                Apotheosis = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/rqFWfVlz/versions/veL1ccTb/Apotheosis-1.21.1-8.9.0.jar";
                  sha512 = "b3022bc31f4e9f99d298c36486e09cad308d4aa87e2aa65a341809aeca41f0067e744086768884959036a46685d4c0babc4274600884ad8962fe9d080d8ef3ee";
                };
                Apotheosis-x-Irons-Spellbook-Compat = pkgs.fetchurl {
                  url = "https://mediafilez.forgecdn.net/files/9234/276/irons_apothic-2.2.8.jar";
                  sha512 = "sha512-Uw/TA8cxr7stEpCOW0vsyYSs8gyZ9l4YKfpOQUTILMbUBfIEN6qBZmrIl7ujCo2Xy+EHVjXFJ1TK4heYTXG2IA==";
                };
                Apothic-Attributes = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/DGaH8Rh0/versions/64fZbLnj/ApothicAttributes-1.21.1-2.11.0.jar";
                  sha512 = "568580e68016161151fc0254fb0da949b42cf285fa2bf7c3aec1cd320405c430483e9eb990aaddef537bfac4aa4beb21db82fbff9249131e05b15063b6839611";
                };
                Apothic-Enchanting = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/pL8MtgqY/versions/JAQJkLJ1/ApothicEnchanting-1.21.1-1.6.4.jar";
                  sha512 = "b560ed61810030472c42fa39e6199b1db07c19baba8f78d98b44ab3e1d00a1bebff5f69942bd076fea9754f63940df920cfb19906073b77bcc459bb8d88575de";
                };
                Apothic-Spawners = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/DfxVkOAO/versions/pWfxcfO2/ApothicSpawners-1.21.1-1.4.0.jar";
                  sha512 = "2fdd49cdb3e6610846c3a746ab0730d6d49412eaf8c21e3d0b9d588d80c8cd1a1d0b7e19ade7fc86fd699ac02e270e5fa01fb5cf106d24a7740692ecc1ad8820";
                };
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

                # WorldGen

                YUNGs-Better-Dungeons = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/o1C1Dkj5/versions/D6aZn0Em/YungsBetterDungeons-1.21.1-NeoForge-5.1.4.jar";
                  sha512 = "40513bacd13fa9860abcab507b1fc09dc51649af4b615ce466e0ec361557f02d35e6e44bea1cc17cb4120805f862aad01394eb185f46611e7be63dfd97f272df";
                };
                YUNGs-Better-Mineshafts = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/HjmxVlSr/versions/Go3nbneL/YungsBetterMineshafts-1.21.1-NeoForge-5.1.1.jar";
                  sha512 = "8b01b386f53feeaa55f0c62697578b82e00501e45e428b2a68df6bda34efb6a4b3b4e3582abf13fe767ebcb61aef9368186f53c03999958bef38f31c41a7f8b2";
                };
                YUNGs-Better-Strongholds = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/kidLKymU/versions/8U0dIfSM/YungsBetterStrongholds-1.21.1-NeoForge-5.1.3.jar";
                  sha512 = "385d67e07f2c67af5ea387d92d92949d8f671e8f99204457b6396dbe987ac3b14c2bff765df5fcbaa68016604f82a1fc6ec5a69c012ca22ad088d1a7c9bc135d";
                };

                # QOL

                AppleSkin = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/uAKA6Laj/appleskin-neoforge-mc1.21-3.0.9.jar";
                  sha512 = "f4ea46273e407334b63e262e2555c9a8204f7b5e60f23f272fbaa83ad9e88800e0ee186aca840710df2dbe0a18b37758695fef2ae1a902c10b3706e3de772937";
                };
                Gravestone-Mod = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/RYtXKJPr/versions/rMGJpjaM/gravestone-neoforge-1.21.1-1.0.40.jar";
                  sha512 = "5504a222d4085da1898ff6d4dff8eb1821fd14a8caaaac785554277147f984262e63925a411db3f1a34e9c7874652fb6737176bea4c0c3f01243f5eae4ea6eaa";
                };
                JEI = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/u6dRKJwZ/versions/1vC6z8wV/jei-1.21.1-neoforge-19.70.0.469.jar";
                  sha512 = "65e9ed5d032e6f284dbdc7f5a41ca43f35ffb9e086419105ee6b360333b1349dc5967bf6ca250f8f02adf73326318945b6c4e57624c0e0a09fc566731e328bc1";
                };
                Waystones = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/LOpKHB2A/versions/6Z6MQ6os/waystones-neoforge-1.21.1-21.1.46.jar";
                  sha512 = "ca90b58d884d4bc2b08a870484ae7ede397e71d31eaaf01ff2603ad498d584763e099c2094e57031522385339705d2c011ed4910bf36efae688e64935b49ece9";
                };
                Xaeros-Minimap = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/1bokaNcj/versions/irjR7dHk/xaerominimap-neoforge-1.21.1-26.6.0.jar";
                  sha512 = "d56b93ddb921285624b491d6a85aba23748bec9974867399c881c257eb25a746df92a735473adf3a6875e0928a56ff78245d5238eb9207b0e45c3fec20c896dc";
                };
              }
            );
          };

          jvmOpts = builtins.concatStringsSep " " [
            "-Xms8G"
            "-Xmx8G"
            "-XX:+UseZGC"
            "-XX:+UseCompactObjectHeaders"
            "-XX:+AlwaysPreTouch"
            "-XX:+DisableExplicitGC"
            "-XX:+PerfDisableSharedMem"
          ];

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
