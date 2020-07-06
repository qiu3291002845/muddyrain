import { Test, TestingModule } from '@nestjs/testing';
import { ComputercpuController } from './computercpu.controller';

describe('Computercpu Controller', () => {
  let controller: ComputercpuController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [ComputercpuController],
    }).compile();

    controller = module.get<ComputercpuController>(ComputercpuController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
