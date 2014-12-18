#!/usr/bin/perl
package MT::EachSlice::Test;
use strict;
use warnings;
use FindBin;
use lib ("$FindBin::Bin/../lib", "$FindBin::Bin/../extlib");
use Test::More;

use MT;
use base qw( MT::Tool );
use Data::Dumper;

sub pp { print STDERR Dumper($_) foreach @_ }

my $VERSION = 0.1;
sub version { $VERSION }

sub help {
    return <<'HELP';
OPTIONS:
    -h, --help             shows this help.
HELP
}

sub usage {
    return '[--help]';
}


## options
my ( $blog_id, $user_id, $verbose );

sub options {
    return (
    )
}

sub uses {
    use_ok('MT::EachSlice::Tags');
}

sub test_template {
    my %args = @_;

    require MT::Builder;
    require MT::Template::Context;
    my $ctx = MT::Template::Context->new;
    my $builder = MT::Builder->new;

    if ( $args{stash} ) {
        $ctx->stash($_, $args{stash}->{$_}) foreach keys %{$args{stash}};
    }
    if ( $args{vars} ) {
        $ctx->var($_, $args{vars}->{$_}) foreach keys %{$args{vars}};
    }

    my $tokens = $builder->compile($ctx, $args{template})
        or die $ctx->errstr || 'Feild to compile.';
    defined ( my $result = $builder->build($ctx, $tokens) )
        or die $ctx->errstr || 'Failed to build.';

    $result =~ s/^\n+//gm;
    $result =~ s/\n\s*\n/\n/gm;
    my @nodes = split( /::/, (caller(1))[3] );
    is($result, $args{expect}, pop @nodes);
}

sub template_split_by_2 {
    my %args = (
        vars => {
            array => [
                { value => 'A' },
                { value => 'B' },
                { value => 'C' },
                { value => 'D' },
                { value => 'E' },
                { value => 'F' },
                { value => 'G' },
            ],
        }
    );

    $args{template} = <<'EOT';
<mt:EachSlice by="2">
<mt:Loop name="array">
<mt:EachSliceHeader><ul></mt:EachSliceHeader>
<mt:EachSliceBody><li><mt:Var name="value"></li></mt:EachSliceBody>
<mt:EachSliceFooter></ul></mt:EachSliceFooter>
</mt:Loop>
</mt:EachSlice>
EOT

    $args{expect} = <<'EOH';
<ul>
<li>A</li>
<li>B</li>
</ul>
<ul>
<li>C</li>
<li>D</li>
</ul>
<ul>
<li>E</li>
<li>F</li>
</ul>
<ul>
<li>G</li>
</ul>
EOH

    test_template(%args);
}

sub tempalte_split_to_2 {
    my %args = (
        vars => {
            array => [
                { value => 'A' },
                { value => 'B' },
                { value => 'C' },
                { value => 'D' },
                { value => 'E' },
                { value => 'F' },
                { value => 'G' },
            ],
        }
    );

    $args{template} = <<'EOT';
<mt:EachSlice to="2">
<mt:Loop name="array">
<mt:EachSliceHeader><ul></mt:EachSliceHeader>
<mt:EachSliceBody><li><mt:Var name="value"></li></mt:EachSliceBody>
<mt:EachSliceFooter></ul></mt:EachSliceFooter>
</mt:Loop>
</mt:EachSlice>
EOT

    $args{expect} = <<'EOH';
<ul>
<li>A</li>
<li>B</li>
<li>C</li>
<li>D</li>
</ul>
<ul>
<li>E</li>
<li>F</li>
<li>G</li>
</ul>
EOH

    test_template(%args);
}

sub main {
    my $mt = MT->instance;
    my $class = shift;

    $verbose = $class->SUPER::main(@_);

    uses;
    template_split_by_2;
    tempalte_split_to_2;
}

__PACKAGE__->main() unless caller;

done_testing();


