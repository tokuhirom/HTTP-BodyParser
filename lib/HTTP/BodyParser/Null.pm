package HTTP::BodyParser::Null;
use strict;
use warnings;
use utf8;
use 5.008_001;

sub new {
    my $class = shift;
    my %args = @_==1 ? %{$_[0]} : @_;
    bless { }, $class;
}

sub add {
    # nop
}

sub params {
    my $self = shift;
    unless (exists $self->{params}) {
        $self->{params} = Hash::MultiValue->new();
    }
    return $self->{params};
}

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

HTTP::BodyParser::Null - null parser

=head1 DESCRIPTION

This parser do nothing. It's useful for handling C<application/octet-stream>.
And other unknown Content-Type.

=head1 CONSTRUCTOR PARAMETERS

Nothing.

