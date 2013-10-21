# NAME

HTTP::BodyParser - HTTP body parser toolkit

# DESCRIPTION

HTTP::BodyParser is set of HTTP body parser.

# Protocol

Parser library __MUST__ have following methods with following signatures.

- `my $parser = HTTP::BodyParser::Foo->new(%args);`

    Create new instance.

    Following parameters are available.

    - content\_length: Int, required

        You must pass this parameter. It's `Content-Length` value to parse.

    - utf8: Bool, optional

        If user set this value as true, BodyParser decode params keys/values and uploads keys.

        Default value: false

- `$parser->add($buffer:Str) :Any`

    Add more buffer string to the parser object.

- `$parser->params() : Hash::MultiValue`

    Parameters in Hash::MultiValue.

- `$parser->uploads() : Hash::MultiValue`

    Uploaded files in Hash::MultiValue.

# LICENSE

Copyright (C) tokuhirom.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

tokuhirom <tokuhirom@gmail.com>
