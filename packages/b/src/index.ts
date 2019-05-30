import * as faker from 'faker';

const foo = () => faker.address.city();

console.log('runs it!');

export default foo;