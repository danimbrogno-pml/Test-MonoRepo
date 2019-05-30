import * as faker from 'faker';

const foo = () => `${faker.address.streetAddress()}, ${faker.address.city()}, ${faker.address.country()}`;

export default foo;