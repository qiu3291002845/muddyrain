import { Test, TestingModule } from '@nestjs/testing';
import { ComputercpuService } from './computercpu.service';

describe('ComputercpuService', () => {
  let service: ComputercpuService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [ComputercpuService],
    }).compile();

    service = module.get<ComputercpuService>(ComputercpuService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
