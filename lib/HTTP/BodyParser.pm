package HTTP::BodyParser;
use 5.008005;
use strict;
use warnings;

our $VERSION = "0.01";

1;
__END__

=encoding utf-8

=head1 NAME

HTTP::BodyParser - HTTP body parser toolkit

=head1 DESCRIPTION

HTTP::BodyParser is set of HTTP body parser.

=head1 Protocol

Parser library B<MUST> have following methods with following signatures.

=over 4

=item C<< my $parser = HTTP::BodyParser::Foo->new(%args); >>

Create new instance.

Following parameters are available.

=over 4

=item content_length: Int, required

You must pass this parameter. It's C<Content-Length> value to parse.

=item utf8: Bool, optional

If user set this value as true, BodyParser decode params keys/values and uploads keys.

Default value: false

=back

=item C<< $parser->add($buffer:Str) :Any >>

Add more buffer string to the parser object.

=item C<< $parser->params() : Hash::MultiValue >>

Parameters in Hash::MultiValue.

=item C<< $parser->uploads() : Hash::MultiValue >>

Uploaded files in Hash::MultiValue.

=back

=head1 LICENSE

Copyright (C) tokuhirom.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

tokuhirom E<lt>tokuhirom@gmail.comE<gt>

=cut

