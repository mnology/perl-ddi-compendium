use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'DDI::Compendium',
    AUTHOR              => 'Erik Johansen <mnology@gmail.com>',
    VERSION_FROM        => 'lib/DDI/Compendium.pm',
    ABSTRACT_FROM       => 'lib/DDI/Compendium.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'DDI-Compendium-*' },
);
