let project = new Project('KhaQuick');
//project.addParameter('-main testTrilateral.testKha2.TestKha2');  <- not sure I can get this to work!!
project.addAssets('assets/**');
project.addSources('src');
project.addShaders('src/Shaders/**');
project.addSources('samples')
project.windowOptions.width = 1024;
project.windowOptions.height = 768;
project.addLibrary('khaMath');
project.addLibrary('justPath');
project.addLibrary('fracs');
resolve( project );