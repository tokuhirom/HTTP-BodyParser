package HTTP::BodyParser::JSON;
use strict;
use warnings;
use utf8;
use 5.008_001;

use Carp ();
use JSON ();
use Encode ();

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
        buffer         => '',
        content_length => $args{content_length},
    }, $class;
}

sub add {
    my $self = shift;
    return unless defined $_[0];

    $self->{buffer} .= $_[0];
    if (length($self->{buffer}) eq $self->{content_length}) {
        my $dat = JSON::decode_json($self->{buffer})
        if ($self->{utf8}) {
            $self->{params} = Hash::MultiValue->from_mixed($dat);
        } else {
            my $params = Hash::MultiValue->new();
            while (my ($k, $v) = each %$dat) {
                if (ref $v eq 'ARRAY') {
                    for (@$v) {
                        $params->add(
                            Encode::encode_utf8($k),
                            Encode::encode_utf8($_),
                        )
                    }
                } else {
                    $params->add(
                        Encode::encode_utf8($k),
                        Encode::encode_utf8($v),
                    )
                }
            }
            $self->{params} = $params;
        }
    }
}

sub params  {
    return $_[0]->{params};
}

sub uploads {
    my $self = shift;
    unless (exists $self->{uploads}) {
        $self->{uploads} = Hash::MultiValue->new();
    }
    return $_[0]->{uploads};
}

1;
__END__

=head1 NAME

HTTP::BodyParser::JSON - application/json parser

=head1 DESCRIPTION

This is a parser libary for application/json content body.

=head1 CONSTRUCTOR ARGUMENTS

=over 4

=item content_length: Int, required.

Value from C<Content-Length> header.

=item utf8: Bool, optional.

If it's true, params' key/value will be decoded.

If your application does not use utf8, you need to set this value as false value. And you need to decode the parameters manually.

Default: false

=back

