import { useState, useRef } from "react";
import { useNavigate } from "react-router-dom";
import { ArrowLeft, Camera, Upload, X, ImagePlus, CheckCircle2 } from "lucide-react";
import { toast } from "sonner";
import { useItems } from "@/context/ItemsContext";
import { Item } from "@/data/types";
import { currentUser } from "@/data/mock-data";

const categories = ["Electronics", "Books", "IDs", "Accessories", "Clothing", "Other"];

const ReportItemScreen = () => {
  const navigate = useNavigate();
  const { addItem } = useItems();

  const [type, setType] = useState<"lost" | "found">("lost");
  const [title, setTitle] = useState("");
  const [category, setCategory] = useState("");
  const [brand, setBrand] = useState("");
  const [description, setDescription] = useState("");
  const [building, setBuilding] = useState("");
  const [floor, setFloor] = useState("");

  const [imageFile, setImageFile] = useState<File | null>(null);
  const [imagePreview, setImagePreview] = useState<string | null>(null);
  const [isDragging, setIsDragging] = useState(false);
  const [isUploading, setIsUploading] = useState(false);
  const [uploadDone, setUploadDone] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleFileSelect = (file: File) => {
    if (!file.type.startsWith("image/")) {
      toast.error("Please select an image file (JPG, PNG, etc.)");
      return;
    }
    if (file.size > 10 * 1024 * 1024) {
      toast.error("Image must be smaller than 10MB");
      return;
    }
    setImageFile(file);
    setUploadDone(false);
    const reader = new FileReader();
    reader.onload = (e) => setImagePreview(e.target?.result as string);
    reader.readAsDataURL(file);
    setIsUploading(true);
    setTimeout(() => {
      setIsUploading(false);
      setUploadDone(true);
      toast.success("Photo uploaded successfully!");
    }, 1500);
  };

  const handleFileInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) handleFileSelect(file);
  };

  const handleDrop = (e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault();
    setIsDragging(false);
    const file = e.dataTransfer.files?.[0];
    if (file) handleFileSelect(file);
  };

  const clearImage = () => {
    setImageFile(null);
    setImagePreview(null);
    setUploadDone(false);
    if (fileInputRef.current) fileInputRef.current.value = "";
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!imageFile) {
      toast.error("Please add a photo of the item");
      return;
    }
    const newItem: Item = {
      id: `item-${Date.now()}`,
      type,
      title,
      category,
      brand: brand || "Unknown",
      building,
      floor: floor || "Not specified",
      description,
      image: imagePreview!,
      ownerId: currentUser.id,
      ownerName: currentUser.name,
      ownerInitials: currentUser.initials,
      status: "active",
      createdAt: new Date().toISOString(),
      timeAgo: "Just now",
    };
    addItem(newItem);
    toast.success("Item reported successfully! It's now live on the feed.");
    navigate("/home");
  };

  const inputClass = "w-full bg-secondary rounded-xl px-4 py-3 text-sm text-foreground placeholder:text-muted-foreground outline-none border border-transparent focus:border-primary/50 transition-colors";

  return (
    <div className="min-h-screen bg-background">
      <div className="flex items-center gap-3 px-4 py-3 border-b border-border">
        <button onClick={() => navigate(-1)} className="w-9 h-9 rounded-full bg-secondary flex items-center justify-center">
          <ArrowLeft className="w-5 h-5 text-foreground" />
        </button>
        <h2 className="font-semibold text-foreground">Report Item</h2>
      </div>

      <form onSubmit={handleSubmit} className="px-5 py-5 space-y-4">
        <div className="flex bg-secondary rounded-xl p-1">
          {(["lost", "found"] as const).map((t) => (
            <button key={t} type="button" onClick={() => setType(t)}
              className={`flex-1 py-2.5 rounded-lg text-sm font-semibold capitalize transition-colors ${
                type === t ? (t === "lost" ? "bg-lost/20 text-lost" : "bg-found/20 text-found") : "text-muted-foreground"
              }`}>
              {t}
            </button>
          ))}
        </div>

        <div className="space-y-2">
          <label className="text-xs font-semibold text-muted-foreground uppercase tracking-wide">
            Photo of Item <span className="text-red-400">*</span>
          </label>
          <input ref={fileInputRef} type="file" accept="image/*" onChange={handleFileInputChange} className="hidden" />

          {imagePreview ? (
            <div className="relative rounded-2xl overflow-hidden border border-border">
              <img src={imagePreview} alt="Item preview" className="w-full h-52 object-cover" />
              <div className="absolute inset-0 flex items-end">
                <div className="w-full bg-gradient-to-t from-black/70 to-transparent px-4 py-3 flex items-center justify-between">
                  {isUploading ? (
                    <div className="flex items-center gap-2 text-white text-sm">
                      <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                      <span>Uploading photo...</span>
                    </div>
                  ) : uploadDone ? (
                    <div className="flex items-center gap-2 text-green-400 text-sm font-medium">
                      <CheckCircle2 className="w-4 h-4" />
                      <span>Photo uploaded</span>
                      {imageFile && <span className="text-white/60 text-xs font-normal">· {(imageFile.size / 1024).toFixed(0)} KB</span>}
                    </div>
                  ) : null}
                  <div className="flex gap-2 ml-auto">
                    <button type="button" onClick={() => fileInputRef.current?.click()}
                      className="bg-white/20 backdrop-blur-sm text-white text-xs px-3 py-1.5 rounded-full border border-white/30 hover:bg-white/30 transition-colors">
                      Change
                    </button>
                    <button type="button" onClick={clearImage}
                      className="bg-red-500/80 backdrop-blur-sm text-white p-1.5 rounded-full hover:bg-red-500 transition-colors">
                      <X className="w-3.5 h-3.5" />
                    </button>
                  </div>
                </div>
              </div>
            </div>
          ) : (
            <div onClick={() => fileInputRef.current?.click()}
              onDrop={handleDrop}
              onDragOver={(e) => { e.preventDefault(); setIsDragging(true); }}
              onDragLeave={() => setIsDragging(false)}
              className={`border-2 border-dashed rounded-2xl h-44 flex flex-col items-center justify-center gap-3 cursor-pointer transition-all ${
                isDragging ? "border-primary bg-primary/5 scale-[0.99]" : "border-border hover:border-primary/50 hover:bg-secondary/50"
              }`}>
              <div className="w-14 h-14 rounded-full bg-primary/10 flex items-center justify-center">
                <ImagePlus className="w-7 h-7 text-primary" />
              </div>
              <div className="text-center">
                <p className="text-sm font-medium text-foreground">{isDragging ? "Drop photo here" : "Tap to add photo"}</p>
                <p className="text-xs text-muted-foreground mt-0.5">JPG, PNG up to 10MB</p>
              </div>
              <div className="flex items-center gap-2 text-xs text-muted-foreground">
                <Camera className="w-3.5 h-3.5" />
                <span>Camera or gallery</span>
              </div>
            </div>
          )}
        </div>

        <input placeholder="Item title" value={title} onChange={(e) => setTitle(e.target.value)} className={inputClass} required />
        <select value={category} onChange={(e) => setCategory(e.target.value)} className={inputClass} required>
          <option value="" disabled>Select category</option>
          {categories.map((c) => <option key={c} value={c}>{c}</option>)}
        </select>
        <input placeholder="Brand (optional)" value={brand} onChange={(e) => setBrand(e.target.value)} className={inputClass} />
        <input placeholder="Building" value={building} onChange={(e) => setBuilding(e.target.value)} className={inputClass} required />
        <input placeholder="Floor / Room" value={floor} onChange={(e) => setFloor(e.target.value)} className={inputClass} />
        <textarea placeholder="Describe the item and where you last saw it..." value={description} onChange={(e) => setDescription(e.target.value)} rows={4} className={`${inputClass} resize-none`} required />

        <button type="submit" className="w-full bg-primary text-primary-foreground py-4 rounded-2xl font-semibold flex items-center justify-center gap-2 text-sm hover:opacity-90 transition-opacity">
          <Upload className="w-4 h-4" />
          Submit Report
        </button>
      </form>
    </div>
  );
};

export default ReportItemScreen;
