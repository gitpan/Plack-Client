package Plack::Client::Backend::http;
BEGIN {
  $Plack::Client::Backend::http::VERSION = '0.03';
}
use strict;
use warnings;
# ABSTRACT: backend for handling HTTP requests

use Plack::App::Proxy;

use base 'Plack::Client::Backend';



sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);

    $self->{proxy} = Plack::App::Proxy->new->to_app;

    return $self;
}

sub _proxy { shift->{proxy} }


sub app_from_request {
    my $self = shift;
    my ($req) = @_;

    my $uri = $req->uri->clone;
    $uri->path('/');
    $req->env->{'plack.proxy.remote'} = $uri->as_string;
    return $self->_proxy;
}

1;

__END__
=pod

=head1 NAME

Plack::Client::Backend::http - backend for handling HTTP requests

=head1 VERSION

version 0.03

=head1 SYNOPSIS

  Plack::Client->new(
      'http' => {},
  );

  Plack::Client->new(
      'http' => Plack::Client::Backend::http->new,
  );

=head1 DESCRIPTION

This backend implements HTTP requests. The current implementation uses
L<Plack::App::Proxy> to make the request.

=head1 METHODS

=head2 new

Constructor. Takes no arguments.

=head2 app_from_request

Takes a L<Plack::Request> object, and returns an app which will retrieve the
HTTP resource.

=head1 SEE ALSO

=over 4

=item *

L<Plack::Client>

=back

=head1 AUTHOR

Jesse Luehrs <doy at tozt dot net>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Jesse Luehrs.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

