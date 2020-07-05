import { NoteBookBrand } from './../../schema/noteBookBrand.schema';
import { TypegooseModule } from 'nestjs-typegoose';
import { Module } from '@nestjs/common';
import { NotebookController } from './notebook.controller';
import { NotebookService } from './notebook.service';

@Module({
  imports: [TypegooseModule.forFeature([NoteBookBrand])],
  controllers: [NotebookController],
  providers: [NotebookService]
})
export class NotebookModule { }
