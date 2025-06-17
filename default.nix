{
  lib,
  pkgs,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
}:
buildNpmPackage (finalAttrs: {
  pname = "edhm-ui";
  version = "3.0.27";

  src = fetchFromGitHub {
    owner = "BlueMystical";
    repo = "EDHM_UI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-258ctkYMltdoyFytZwhV9ga65MdVUAml9BMFt20/b7U=";
  };

  postPatch = ''
    cp "${./package-lock.json}" ./source_v3/package-lock.json
    cp "${./forge.config.js}" ./source_v3/forge.config.js
  '';
  npmRoot = "source_v3";

  npmDeps = fetchNpmDeps {
    src = finalAttrs.src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.npmRoot}";
    postPatch = ''
      cp "${./package-lock.json}" ./package-lock.json
    '';
    hash = "sha256-AWi6xRMd0d6H6a8xCqYVrqB0SejRHULLsszX4ZeIA0A=";
  };
  makeCacheWritable = true;

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    makeWrapper
    electron
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  };

  buildPhase = ''
    runHook preBuild
    cd ${finalAttrs.npmRoot}
    npm run make -- --arch="x64" --targets="@electron-forge/maker-zip"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r ${finalAttrs.npmRoot}/out/make/zip/x64/*.zip $out/
    runHook postInstall
  '';

  meta = {
    description = "Elite Dangerous HUD Mod";
    homepage = "https://bluemystical.github.io/edhm-api/index.html";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
  };
})
