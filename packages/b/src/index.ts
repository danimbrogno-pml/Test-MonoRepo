import * as faker from 'faker';

const foo = () => `${faker.address.streetAddress()}, ${faker.address.city()}, ${faker.address.state()}, ${faker.address.country()}!!`;

export default foo;