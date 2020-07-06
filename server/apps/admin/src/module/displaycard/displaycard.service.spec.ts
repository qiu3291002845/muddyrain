import { Test, TestingModule } from '@nestjs/testing';
import { DisplaycardService } from './displaycard.service';

describe('DisplaycardService', () => {
  let service: DisplaycardService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [DisplaycardService],
    }).compile();

    service = module.get<DisplaycardService>(DisplaycardService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
