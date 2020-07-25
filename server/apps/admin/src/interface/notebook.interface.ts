import { displayCard } from './../schema/displayCard.schema';
import { computerCpu } from './../schema/computerCpu';
import { NoteBookBrand } from './../schema/noteBookBrand.schema';
import { Ref } from '@typegoose/typegoose';
export interface NotebookDto {
  name: string;
  brand: Ref<NoteBookBrand>
  color: string;
  subtitle: string;
  price: string;
  resolution: string;
  cpu: Ref<computerCpu>;
  displayCard: Ref<displayCard>;
  size: string;
  ram: string;
  hardDisk: string;
  hardDiskCapacity: string;
  os: string;
  imageUrl: [''];
}
