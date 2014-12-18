package MT::EachSlice::Tags;

use strict;

sub plugin { MT->component('EachSlice') }

sub _tag_EachSlice {
    my ( $ctx, $args, $cond ) = @_;
    my $tokens = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');

    # Params: by or to
    my ( $by, $to );
    if ( $by = $args->{by} ) { }
    elsif ( $to = $args->{to} ) { }
    else {
        return $ctx->error(plugin->translate('mt:EachSlice requires one of "by" or "to" attribute.'));
    }

    # Param: glue
    my $glue = $args->{glue};
    $glue = "\n" unless defined $glue;

    # Collect parts
    local $ctx->{__stash}{each_slice} = { header => '', bodies => [], footer => '' };
    defined( my $partial = $builder->build($ctx, $tokens) )
        or return $ctx->error($builder->errstr);

    # Combine array
    my @arrays;
    my $hash = $ctx->{__stash}->{each_slice};
    my $bodies = $hash->{bodies};

    # Convert split-to to split-by
    if ( $to ) { $by = int( (scalar @$bodies) / $to ) + 1; }
    return $ctx->error(plugin->translate('mt:EachSlice cannot split by 0.')) if $by < 1;

    # Slice to group of array
    push @arrays, [ splice(@$bodies, 0, $by) ] while @$bodies;

    # Join header, bodies, footer foreach group
    my $result = join($glue, map { $hash->{header}, join($glue, @$_), $hash->{footer} } @arrays);

    $result;
}

sub _tag_EachSliceBody {
    my ( $ctx, $args, $cond ) = @_;
    my $tokens = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');

    my $hash = $ctx->{__stash}{each_slice}
        || return $ctx->error(plugin->translate('mt:[_1] must be included in mt:EachSlice', $ctx->tag));
    my $bodies = $hash->{bodies} ||= [];

    # Build inside
    defined( my $partial = $builder->build($ctx, $tokens) )
        or return $ctx->error($builder->errstr);

    # Push to bodies
    push @$bodies, $partial;

    '';
}

sub _tag_EachSliceHeader {
    _tag_EachSlicePart('header', @_);
}

sub _tag_EachSliceFooter {
    _tag_EachSlicePart('footer', @_);
}

sub _tag_EachSlicePart {
    my ( $part, $ctx, $args, $cond ) = @_;
    my $tokens = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');

    my $hash = $ctx->{__stash}{each_slice}
        || return $ctx->error(plugin->translate('mt:[_1] must be included in mt:EachSlice', $ctx->tag));

    # Build inside
    defined( my $partial = $builder->build($ctx, $tokens) )
        or return $ctx->error($builder->errstr);

    # Set to partial
    $hash->{$part} = $partial;

    '';
}

1;