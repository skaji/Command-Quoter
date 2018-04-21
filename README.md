[![Build Status](https://travis-ci.org/skaji/Command-Quoter.svg?branch=master)](https://travis-ci.org/skaji/Command-Quoter)

# NAME

Command::Quoter - quote commands

# SYNOPSIS

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

# DESCRIPTION

Command::Quoter is

# AUTHOR

Shoichi Kaji <skaji@cpan.org>

# COPYRIGHT AND LICENSE

Copyright 2018 Shoichi Kaji <skaji@cpan.org>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
