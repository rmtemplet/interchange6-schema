use strict;
use warnings;

use Data::Dumper;
use Test::More tests => 1;
use Try::Tiny;
use DBICx::TestDatabase;
use Interchange6::Schema;

my $now = time();

my $schema = DBICx::TestDatabase->new('Interchange6::Schema');

my %cart;
my %carrier;
my %rule;
my %destination;

$destination{US} = $schema->resultset("ShipmentDestination")->populate([
    { country_iso_code => 'US', shipment_methods_id =>'1' },
]);

$carrier{UPS} = $schema->resultset("ShipmentCarrier")->create(
    {
        name => 'UPS',
        account_number => '1Z9999',
            ShipmentMethod => [
            {
                name => 'GNDRES',
                title => 'Ground Residential',
            },
            ],
    }
);

my $rule_rs = $schema->resultset('Rule');

$rule{1} = $rule_rs->create(
    {
        rules_id =>'1',
        name => 'action',
        title => 'Action',
        description => 'This master rule begins an action',
        strict => '1',
    },
);

$rule{2} = $rule_rs->create(
    {
        rules_id =>'2',
        name => 'Action Discount 100 percent',
        description => 'Action creates a discount',
        canonical_rules_id => '1',
        strict => '1',
    },
);

$rule{3} = $rule_rs->create(
    {
        rules_id =>'3',
        name => 'class',
        title => 'Result Class Dependency',
        description => 'This master rule begins a result class dependency',
        strict => '1',
    },
);
$rule{4} = $rule_rs->create(
    {
        rules_id =>'4',
        name => 'Destination United States UPS Ground Shipping',
        description => 'This rule makes ShipmentDestination US with Shipping Method UPS Ground a relationship',
        canonical_rules_id => '3',
        strict => '1',
    },
);
$rule{5} = $rule_rs->create(
    {
        rules_id =>'5',
        name => 'operator',
        title => 'Operator',
        description => 'This mater rule begins an operator.',
        strict => '1',
    },
);
$rule{6} = $rule_rs->create(
    {
        rules_id =>'6',
        name => '>=',
        title => 'Greater than or equal $50.00',
        description => 'This operator checks for a numeric value greater than or equal to another value',
        canonical_rules_id => '5',
        strict => '1',
    },
);
$rule{7} = $rule_rs->create(
    {
        rules_id =>'7',
        name => 'type',
        title => 'Type',
        description => 'This master role Type is a required in RoleLine .',
        strict => '1',
    },
);

$rule{8} = $rule_rs->create(
    {
        rules_id =>'8',
        name => 'Cart : Shipping value rule',
        description => 'This  value',
        canonical_rules_id => '7',
        strict => '1',
    },
);

# Action: discount 100%
$rule{2}->add_attribute({ name => 'action'}, 'discount');
$rule{2}->add_attribute({ name => 'action_type'}, 'percentage');
$rule{2}->add_attribute({ name => 'value'}, '100');

# Condition: Greater than or equal 50.00
$rule{6}->add_attribute({ name => 'operator'}, '>=');
$rule{6}->add_attribute({ name => 'value'}, 50.00);

# Result: Result class ShipmentDestination primary key 1 US
$rule{4}->add_attribute({ name => 'base_class'}, 'ShipmentDestination');
$rule{4}->add_attribute({ name => 'field'}, 'id');

# Object: Cart object with field focus on shipping
$rule{8}->add_attribute({ name => 'rule_type'}, 'Cart');
$rule{8}->add_attribute({ name => 'field'}, 'shipping');

# shipping rule group
$cart{rule} = $schema->resultset("RuleGroup")->create(
{ name => 'UPSFUS50', title => 'Free Domestic UPS Ground Shipping Over $50', valid_from => $now,
    RuleGroupline => [
        {
            rules_id => '2',
        },
        {
            rules_id => '4',
        },
        {
            rules_id => '6',
        },
        {
            rules_id => '8',
        },
    ]
});

ok($cart{rule}->name eq 'UPSFUS50', "Testing RuleGroup id.")
    || diag "RuleGroup id: " . $cart{rule}->name;
