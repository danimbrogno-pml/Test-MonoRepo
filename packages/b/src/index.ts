import * as faker from 'faker';

const foo = () => `${faker.address.streetAddress()}\n ${faker.address.city()}, ${faker.address.country()}`;

export default foo;