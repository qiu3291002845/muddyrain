import { Test, TestingModule } from '@nestjs/testing';
import { DisplaycardController } from './displaycard.controller';

describe('Displaycard Controller', () => {
  let controller: DisplaycardController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [DisplaycardController],
    }).compile();

    controller = module.get<DisplaycardController>(DisplaycardController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
