package App::Prove::History::State::Result;

use strict;
use warnings;
use aliased 'App::Prove::History::State::Result::Test';

use base 'App::Prove::State::Result';

=head2 C<test_class>

Returns the name of the class used for tracking individual tests.  This class
should either subclass from C<App::Prove::State::Result::Test> or provide an
identical interface.

=cut

sub test_class {
    return Test;
}

1;
