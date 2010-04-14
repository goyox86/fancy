#ifndef _FILE_H_
#define _FILE_H_

namespace fancy {

  class File : public FancyObject
  {
  public:
    File(const string &filename, const string &mode, FILE *file);
    File(const string &filename, const string &mode);
    virtual ~File();

    virtual FancyObject_p equal(const FancyObject_p other) const;
    virtual OBJ_TYPE type() const;
    virtual string to_s() const;

    string filename() const;
    string mode() const;
    FILE* file() const;

    void open();
    bool is_open();
    bool eof();
    void close();

  private:
    string _filename;
    string _mode;
    FILE *_file;
  };

  typedef File* File_p;

}

#endif /* _FILE_H_ */
