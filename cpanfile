requires 'perl', '5.008001';
requires 'URL::Encode';
requires 'JSON', 2;
requires 'HTTP::MultiPart::Parser';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

