package HTTP::BodyParser::UrlEncoded;
use strict;
use warnings;
use utf8;
use 5.008_001;

use URL::Encode;

sub new {
    my $class = shift;
    my %args = @_==1 ? %{$_[0]} : @_;

    unless (exists $args{content_length}) {
        Carp::croak("Missing mandatory paramter: content_length");
    }
    if ($args{content_length} eq 0) {
        Carp::croak("content_length must not be zero");
    }

    bless {
        utf8           => $args{utf8},
        content_length => $args{content_length},
        buffer         => '',
    }, $class;
}

sub add {
    my $self = shift;
    return unless defined $_[0];

    $self->{buffer} .= $_[0];
    if (length($self->{buffer}) eq $self->{content_length}) {
        $self->{params} = Hash::MultiValue->new(
            URL::Encode::url_params_flat(
                $self->{buffer},
                $self->{utf8}
            )
        );
    }
}

sub params  { $_[0]->{params} }

sub uploads {
    my $self = shift;
    unless (exists $self->{uploads}) {
        $self->{uploads} = Hash::MultiValue->new();
    }
    return $self->{uploads};
}

1;
__END__

=head1 NAME

HTTP::BodyParser::UrlEncoded - application/x-www-form-urlencoded parser

=head1 SYNOPSIS

    my $parser = HTTP::BodyParser::UrlEncoded->new(
        content_length => $content_length,
    );
    while (my $buffer = $input->read()) {
        $parser->add($buffer);
    }
    my $params = $parser->params();

=head1 DESCRIPTION

This is a part of HTTP::BodyParser library toolkit.

This module parses application/x-www-form-urlencoded using L<URL::Encode>.

=head1 CONSTRUCTOR ARGUMENTS

=over 4

=item content_length: Int, required.

Value from C<Content-Length> header.

=item utf8: Bool, optional.

If it's true, params' key/value will be decoded.

If your application does not use utf8, you need to set this value as false value. And you need to decode the parameters manually.

Default: false

=back

=head1 SEE ALSO

L<URL::Encode> is a fast url decoder.

This module is inspired from L<HTTP::Body::UrlEncoded>.

