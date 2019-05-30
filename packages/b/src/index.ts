import * as faker from 'faker';

const foo = () => `${faker.address.streetAddress()}, \n ${faker.address.city()},\n ${faker.address.state()},\n ${faker.address.country()}!!`;

export default foo;