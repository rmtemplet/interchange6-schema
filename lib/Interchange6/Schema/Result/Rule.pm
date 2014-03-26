use utf8;
package Interchange6::Schema::Result::Rule;

=head1 NAME

Interchange6::Schema::Result::Rule;

=cut

use strict;
use warnings;

use base qw(DBIx::Class::Core Interchange6::Schema::Base::Attribute);

__PACKAGE__->load_components(qw(InflateColumn::DateTime TimeStamp));

=head1 TABLE: C<rules>

=cut

__PACKAGE__->table("rules");

=head1 DESCRIPTION

The rules table contains parameters for various rule types. 

Rules are broken into 4 parts.

=over

=item *

B<Object> The rule object defines the object that it will effect. An example of a rule object
is Cart.

=item *

B<Action> The action of the rule designates what resulting action the rule will perform.
An example of an action is a discount.  The action is dependent on the critera of
the condition (see below).

=item *

B<Condition> The condition which is required gives the action a critera to be met before
the action can be made.  A full condition might look like this.

# Condition greater than or equal 50.00
$myrule->add_attribute({ name => 'condition'}, '>=');
$myrule->add_attribute({ name => 'value'}, 50.00);

=item *

B<Result> Adding a result class to a rule allows the data from that class to be used for
defining the rule.

=back

=cut

=head1 ACCESSORS

=head2 rules_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 title

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0

=head2 description

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 0

=head2 canonical_rules_id

  This field contains the rules_id of the master rule for which it is 
  dependent. If the field is blank it is assumed to be a master rule.

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 strict

  If the master rule is flagged strict no other attributes can be created
  for this rule only attribute_values.

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=head2 active

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "rules_id",
  {
    data_type => "integer",
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "title",
  { data_type => "varchar", default_value => "", is_nullable => 0 },
  "description",
  { data_type => "text", default_value => "", is_nullable => 0 },
  "canonical_rules_id",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "strict",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
  "active",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</rules_id>

=back

=cut

__PACKAGE__->set_primary_key("rules_id");

=head1 RELATIONS

=head2 RuleAttribute

Type: has_many

Related object: L<Interchange6::Schema::Result::RuleAttribute>

=cut

__PACKAGE__->has_many(
  "RuleAttribute",
  "Interchange6::Schema::Result::RuleAttribute",
  { "foreign.rules_id" => "self.rules_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

1;
