import * as faker from 'faker';

const foo = () => `My address is: ${faker.address.city()} ${faker.address.country()}`;

export default foo;