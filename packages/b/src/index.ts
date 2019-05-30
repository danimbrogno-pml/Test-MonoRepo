import * as faker from 'faker';

const foo = () => faker.address.city();

console.log('runs b');

export default foo;