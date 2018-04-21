package Command::Quoter;
use strict;
use warnings;

our $VERSION = '0.001';

use constant WIN32 => $ENV{PERL_COMMAND_QUOTER_WIN32} || $^O eq 'MSWin32';
use if  WIN32, 'Win32::ShellQuote';
use if !WIN32, 'String::ShellQuote';

use String::Formatter;

use Exporter 'import';
our @EXPORT_OK = qw(quote qxq systemq execq);

my $quote = sub {
    my $str = shift;
    my $quoted;
    if (WIN32) {
        $quoted = Win32::ShellQuote::quote_native($str);
    } else {
        $quoted = String::ShellQuote::shell_quote_best_effort($str);
    }
    $quoted;
};

my $formatter = String::Formatter->new({
    input_processor => 'require_named_input',
    string_replacer => 'named_replace',
    codes => {
        q => sub { $quote->($_) },
        s => sub { $_ },
    },
});

sub new {
    bless {}, shift;
}

sub quote {
    shift if $_[0] eq __PACKAGE__ or $_[0]->isa(__PACKAGE__);
    $formatter->format(@_);
}

sub system :method {
    my $quoted = shift->quote(@_);
    system $quoted;
}

sub qx {
    my $quoted = shift->quote(@_);
    qx{$quoted};
}

sub exec :method {
    my $quoted = shift->quote(@_);
    exec $quoted;
}

sub systemq {
    __PACKAGE__->system(@_);
}

sub qxq {
    __PACKAGE__->qx(@_);
}

sub execq {
    __PACKAGE__->exec(@_);
}

1;
__END__

=encoding utf-8

=head1 NAME

Command::Quoter - quote commands

=head1 SYNOPSIS

  use Command::Quoter;

  my $quoter = Command::Quoter->new;

  my $quoted = $quoter->quote("%{make}q install", { make => 'C:\\Program Files\\bin\\make.exe' });

  my $exit = $quoter->system("%{gzip}q -dc %{infile}q | %{tar}q tf - > %{outfile}q", {
    gzip    => 'gzip',
    infile  => 'input.tar.gz',
    tar     => 'tar',
    outfile => 'out',
  });

  my $out = $quoter->qx("%{cpansign}a -v --skip 2>&1", { cpansign => 'cpansign' });

  # as functions
  use Command::Quoter qw(quote systemq qxq);

  my $quoted = quote "%{make}q install", { make => 'C:\\Program Files\\bin\\make.exe' };

  my $exit = systemq "%{gzip}q -dc %{infile}q | %{tar}q tf - > %{outfile}q", {
    gzip    => 'gzip',
    infile  => 'input.tar.gz',
    tar     => 'tar',
    outfile => 'out',
  };

  my $out = qxq "%{cpansign}q -v --skip 2>&1", { cpansign => 'cpansign' };

=head1 DESCRIPTION

Command::Quoter is

=head1 AUTHOR

Shoichi Kaji <skaji@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright 2018 Shoichi Kaji <skaji@cpan.org>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
