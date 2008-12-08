use inc::Module::Install;
name 'Module-Version-Compare';
all_from 'lib/Module/Version/Compare.pm';
requires 'Class::Accessor::Fast';
build_requires 'Test::More';
build_requires 'File::Spec';
use_test_base;
auto_install;
WriteAll;
