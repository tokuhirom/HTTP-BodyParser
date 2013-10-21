package HTTP::BodyParser::MultiPart;
use strict;
use warnings;
use utf8;
use 5.010_001;

use HTTP::MultiPart::Parser;
use Encode ();

sub new {
    my $class = shift;
    my %args = @_==1 ? %{$_[0]} : @_;

    unless (exists $args{content_type}) {
        Carp::croak("Missing mandatory paramter: content_type");
    }
    unless (exists $args{content_length}) {
        Carp::croak("Missing mandatory paramter: content_length");
    }
    if ($args{content_length} eq 0) {
        Carp::croak("content_length must not be zero");
    }

    bless {
        utf8    => $args{utf8},
        parser  => HTTP::MultiPart::Parser->new(
            content_type => $args{content_type},
        ),
        uploads => Hash::MultiValue->new(),
        params  => Hash::MultiValue->new(),
        content_length => $args{content_length},
    }, $class;
}

sub add {
    my $self = shift;
    return unless defined $_[0];

    $self->{parser}->add($_[0]);
    $self->{length} += length($_[0]);

    if ($self->{length} eq $self->{content_length}) {
        for my $part (@{$self->{parser}->parts}) {
            if (exists $part->{filename}) {
                if ($self->{utf8}) {
                    $self->{params}->add(
                        Encode::decode_utf8($part->{name}),
                        Encode::decode_utf8($part->{data})
                    );
                } else {
                    $self->{params}->add(
                        $part->{name},
                        $part->{data}
                    );
                }
            } else {
                if ($self->{utf8}) {
                    $self->{uploads}->add(
                        Encode::decode_utf8($part->{name}),
                        $part
                    );
                } else {
                    $self->{uploads}->add(
                        $part->{name},
                        HTTP::Request::Upload->new(
                            $part
                        )
                    );
                }
            }
        }
    }
}

sub params  { $_[0]->{params}  }

sub uploads { $_[0]->{uploads} }

1;
__END__

=head1 NAME

HTTP::BodyParser::MultiPart - multipart/form-data parser

=head1 DESCRIPTION

multipart/form-data parser library based on L<HTTP::MultiPart::Parser>.

=head1 CONSTRUCTOR ARGUMENTS

=over 4

=item utf8: Bool

When you set this key as true, 'params' key/value and 'uploads' key will be decode.

Default: false

=item content_type: Str, required

C<Content-Type> header value.

=item content_length: Int, required

C<Content-Length> header value.

=back

