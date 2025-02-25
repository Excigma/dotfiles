{ pkgs, self, ... }: {

  nixpkgs.overlays = with self.inputs; [
    nur.overlays.default

    (final: prev: {

      go-10mb-video = pkgs.buildGoModule {
        pname = "10mb-video";
        version = "14e8aaac56189d48418d157171bae10f2ea9defd";

        src = pkgs.fetchFromGitHub {
          owner = "ugjka";
          repo = "10mb.video";
          rev = "14e8aaac56189d48418d157171bae10f2ea9defd";
          sha256 = "sha256-mcpQ6AVAXJjNbClUF6pgZbU47KCn4viaA6fB7eF7CZg";
        };

        vendorHash = null;
        subPackages = [ "." ];
        buildInputs = with pkgs; [ ffmpeg fdk-aac-encoder ];

        meta = with pkgs.lib; {
          description = "Fit a video into a 10mb file (Discord nitro pls?)";
          homepage = "https://github.com/ugjka/10mb.video";
          license = licenses.mit;
          maintainers = [ ];
          platforms = platforms.all;
          mainProgram = "10mb.video";
        };
      };

    })
  ];

}
