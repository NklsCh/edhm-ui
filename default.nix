{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps
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
  '';
  makeCacheWritable = true;
  npmRoot = "source_v3";

  npmDeps = fetchNpmDeps {
    src = finalAttrs.src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.npmRoot}";
    postPatch = ''
     cp "${./package-lock.json}" ./package-lock.json
    '';
    hash = "sha256-AWi6xRMd0d6H6a8xCqYVrqB0SejRHULLsszX4ZeIA0A=";
  };

  meta = {
    description = "Elite Dangerous HUD Mod";
    homepage = "https://bluemystical.github.io/edhm-api/index.html";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
  };
})
