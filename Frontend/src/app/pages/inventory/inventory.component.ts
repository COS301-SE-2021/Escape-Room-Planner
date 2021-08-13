import {Component, ElementRef, EventEmitter, OnInit, Output, Renderer2, ViewChild} from '@angular/core';
import {HttpClient, HttpHeaders} from "@angular/common/http";
import {toBase64String} from "@angular/compiler/src/output/source_map";
import {File} from "@angular/compiler-cli/src/ngtsc/file_system/testing/src/mock_file_system";

@Component({
  selector: 'app-inventory',
  templateUrl: './inventory.component.html',
  styleUrls: ['./inventory.component.css']
})
export class InventoryComponent implements OnInit {
  private headers: HttpHeaders = new HttpHeaders();
  private inventory: inventory_images = [] as any;

  @Output() public afterClick: EventEmitter<inventoryObject> = new EventEmitter();
  @Output() public error: EventEmitter<inventoryObject> = new EventEmitter();
  @ViewChild('container_div') container_div: ElementRef | undefined;
  @ViewChild('puzzle_div') puzzle_div: ElementRef | undefined;
  @ViewChild('key_div') key_div: ElementRef | undefined;
  @ViewChild('clue_div') clue_div: ElementRef | undefined;

  constructor(private httpClient: HttpClient, private renderer: Renderer2) {
    this.headers = this.headers.set('Authorization', 'Bearer ' + localStorage.getItem('token'));
  }

  ngOnInit(): void {

    this.httpClient.get<any>('http://127.0.0.1:3000/api/v1/inventory/',{"headers": this.headers}).subscribe(
      response =>{
        this.loadInventory(response.image);
      },
      error => {
        console.error(error.statusText);
        this.error.emit();
      }
    );
  }

  public loadInventory(images: Array<image_object>): void{
    for (let image of images){
      let blob_id = image.blob_id.toString();
      this.inventory[blob_id] = image.src;
      this.renderInventoryObject(blob_id, image.type);
    }
  }

  private renderInventoryObject( blob_id: string, type:string){
    // <div class="col">
    // <img src="./assets/images/key1.png" (click)="onClick('Keys', 'key1.png',10)" alt="NOT FOUND" class="img-thumbnail">
    // <p class="text-center text-black-50">Key 1</p>
    // </div>
    let new_div = this.renderer.createElement('div');
    let new_img = this.renderer.createElement('img');
    let new_p = this.renderer.createElement('p');
    // setting classes
    this.renderer.addClass(new_div,'col');
    this.renderer.addClass(new_img, 'img-thumbnail');
    this.renderer.addClass(new_p, 'text-center');
    this.renderer.addClass(new_p, 'text-black-5');
    // setting text, change later todo
    new_p.textContent = type;
    // setting src
    this.renderer.setAttribute(new_img,'src', this.inventory[blob_id]);
    this.renderer.setAttribute(new_img, 'alt', type + 'inventory object');

    //CHILDREN
    this.renderer.appendChild(new_div, new_img);
    this.renderer.appendChild(new_div, new_p);
    // RENDER
    switch (type){
      case 'container':{
        this.renderer.appendChild(this.container_div?.nativeElement, new_div)
        break;
      }
      case 'puzzle':{
        this.renderer.appendChild(this.puzzle_div?.nativeElement, new_div)
        break;
      }
      case 'key':{
        this.renderer.appendChild(this.key_div?.nativeElement, new_div)
        break;
      }
      case 'clue':{
        this.renderer.appendChild(this.clue_div?.nativeElement, new_div)
        break;
      }
    }
  }

  public onClick(type:string, loc:string, pos:number): void{
    let data: inventoryObject = {
      type: type,
      loc: loc,
      pos: pos
    }

    this.afterClick.emit(data);
  }

  public async addImage(input: HTMLInputElement | null, type: 'container' | 'puzzle' | 'key' | 'clue'): Promise<void> {
    let file = input?.files?.item(0);


    if (file != null && file.size < 1000000 && file.type.includes('image')) {
      // send request ot back end render piece on front
      let image = (await this.toBase64(file) as string).replace('data:image/jpeg;base64,', '');

      this.httpClient.post<any>("http://127.0.0.1:3000/api/v1/inventory/", {image: image, type: type}
        , {"headers": this.headers}).subscribe(
        response => {
          console.log(response);
        },
        error => {
          console.error(error);
          this.error.emit();
        }
      );
    } else {
      alert('file size too large or not an image');
    }
  }

  private toBase64(file:Blob):Promise<any>{
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = () => resolve(reader.result);
      reader.onerror = error => reject(error);
    });
  }

  public addImage_2(event:any){
    // let file = input?.files?.item(0);
    let form = new FormData(event.target);
    console.log(form);
      // send request ot back end render piece on front
      this.httpClient.post<any>("http://127.0.0.1:3000/api/v1/inventory/", form
        ,{"headers":this.headers}).subscribe(
        response =>{
          console.log(response);
        },
        error =>{
          console.error(error);
          this.error.emit();
        }
      );
  }
}

interface inventoryObject{
  type: string,
  loc: string,
  pos: number
}

interface image_object{
  blob_id: number,
  src: string,
  type: string
}

interface inventory_images{
  [key: string]: string
}
